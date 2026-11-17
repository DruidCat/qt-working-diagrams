"""Пересборка иконок приложения.

GIMP-скругление в исходных PNG без антиалиасинга: альфа только 0/255, на
Авроре лаунчер растягивает зубцы и даёт белые засветы. Скрипт пересобирает
иконки с аналитической AA-маской скругления (8x суперсэмплинг, straight
alpha) — тот же результат, что рендер SVG, но без внешних тулз.

Запуск из корня репозитория: python3 tools/rebuild_icons.py
"""
import math

from PIL import Image, ImageDraw, ImageFilter

SRC = 'icons/172x172/ru.Mentor.png'
SIZES = [172, 128, 108, 86]
SS = 8  # коэффициент суперсэмплинга маски


def make_master(im):
    """Полный квадрат: RGB под прозрачными углами из ближайшего непрозрачного."""
    rgb = im.convert('RGB')
    alpha = im.split()[3]
    opaque = alpha.point(lambda v: 255 if v == 255 else 0)
    for _ in range(64):  # dilation по кольцам; глубина угла ~10 px на 172
        dil = rgb.filter(ImageFilter.MaxFilter(3))
        rgb = Image.composite(rgb, dil, opaque)
        opaque = opaque.filter(ImageFilter.MaxFilter(3))
        if opaque.getextrema() == (0, 0):
            break
    return rgb


def corner_radius(im):
    """Радиус по первой непрозрачной точке диагонали (угол срезан дугой).

    Проверка по нескольким строкам: для левого края fit по дуге окружности
    (x - R)^2 + (y - R)^2 = R^2 в угловой области.
    """
    px = im.load()
    n = im.size[0]
    first = min(x for x in range(n) if px[x, x][3] > 0)
    # дуга касается диагонали в (t,t): t = R*(1 - 1/sqrt(2)); берём середину
    # угловой зоны (y = R/2), где x_left = R - sqrt(R^2 - (R/2)^2)
    pts = []
    for y in range(1, 20):
        xs = [x for x in range(n) if px[x, y][3] > 0]
        if xs:
            pts.append((y, xs[0]))
    best, best_err = None, 1e9
    for R10 in range(100, 800, 5):
        R = R10 / 10.0
        err = sum((x0 - (R - math.sqrt(max(R * R - (R - y) * (R - y), 0)))) ** 2
                  for y, x0 in pts)
        if err < best_err:
            best, best_err = R, err
    print('диагональ: первая непрозрачная в (%d,%d); фит дуги R=%.1f (err=%.2f)'
          % (first, first, best, best_err))
    return best


def masked(im, rad):
    n = im.size[0]
    big = Image.new('L', (n * SS, n * SS), 0)
    d = ImageDraw.Draw(big)
    d.rounded_rectangle([0, 0, n * SS - 1, n * SS - 1], rad * SS, fill=255)
    out = im.convert('RGBA')
    out.putalpha(big.resize((n, n), Image.Resampling.LANCZOS))
    return out


def main():
    src = Image.open(SRC).convert('RGBA')
    w = src.size[0]
    master = make_master(src)
    r0 = corner_radius(src)
    print('радиус скругления мастера: %.1f px' % r0)
    outs = {}
    for s in SIZES:
        im = master if s == w else master.resize((s, s), Image.Resampling.LANCZOS)
        out = masked(im, r0 * s / w)
        outs[s] = out
        out.save(f'icons/{s}x{s}/ru.Mentor.png', optimize=True)
        px = out.load()
        white = sum(1 for y in range(s) for x in range(s)
                    if px[x, y][3] > 0 and min(px[x, y][:3]) > 200)
        semi = sum(1 for y in range(s) for x in range(s)
                   if 0 < px[x, y][3] < 255)
        print(f'{s}x{s}: белых пикселей={white}, полупрозрачных (AA)={semi}')
    outs[86].save('icons/ico/ru.Mentor.ico', sizes=[(86, 86)])
    print('готово')


if __name__ == '__main__':
    main()
