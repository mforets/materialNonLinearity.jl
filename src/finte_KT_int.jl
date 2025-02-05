# 
# Computes Internal force and tanget stiffness matrix
#

function finte_KT_int(material, l, secParams, Uke, intBool)


    KTe = zeros(4, 4)
    Finte = zeros(4)

    # Section
    b = secParams[1]
    h = secParams[2]

    # Gauss points
    ne = 12
    ns = 12
    xge, we = gausslegendre(ne)
    xgs, ws = gausslegendre(ns)

    pgeVec = l / 2 * xge .+ l / 2
    pgsVec = h / 2 * xgs

    for j in 1:length(we)

        secFinte = 0
        secKTe = 0

        pge = pgeVec[j]

        # Bending inter functions second derivative
        B = internFunction(pge, l)

        # Strain array
        epskVec = -pgsVec * B * Uke

        for m in 1:length(ws)
            pgs = pgsVec[m]
            epsk = epskVec[m]

            sigma, dsigdeps = constitutiveModel(material, epsk)

            secFinte = h / 2 * (b * (-B') * pgs * sigma * ws[m]) .+ secFinte

            if intBool == 1
                secKTe = l / 2 * (b * dsigdeps * pgs^2 * ws[m]) + secKTe
            end

        end # endfor ws

        # Tangent stiffness matrix
        if intBool == 1
            KTe = h / 2 * (B' * secKTe * B * we[j]) + KTe
        end

        # Internal force
        Finte = l / 2 * we[j] * secFinte + Finte

    end

    return Finte, KTe
end

function internFunction(x, l)
    N1 = (12x - 6l) / l^3
    N2 = (6x - 4l) / l^2
    N3 = -(12x - 6l) / l^3
    N4 = (6x - 2l) / l^2
    f = [N1 N2 N3 N4]
    return f
end