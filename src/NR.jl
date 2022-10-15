# Newton-Raphson 
# =====================================

function NR(section, material, mesh, Uk, modelSol, time, analysisSettings, dispIter, KTk, Fintk)

    println(dispIter)
    ndofs = 2 # degrees of freedom per node
    nnodes = size(mesh.nodesMat, 1)
    nelems = size(mesh.conecMat, 1)
    Fextk = modelSol.Fextk

    # Solve system
    freeDofs = modelSol.freeDofs

    KTkred = KTk[freeDofs, freeDofs]
    Fext_red = Fextk[freeDofs]
    Fint_red = Fintk[freeDofs]
    r = Fext_red - Fint_red

    deltaUk = KTkred \ r


    # Computes Uk
    Uk[freeDofs] = Uk[freeDofs] + deltaUk

    #=
        # Internal forces at converged Uk
        FintkL = zeros(nnodes * ndofs)
        Fintk = zeros(nnodes * ndofs, 1)
        for i in 1:nelems
            # Elem nodes, dofs, material and geometry
            nodeselem = mesh.conecMat[i, 3]
            elemdofs = nodes2dofs(nodeselem[:], ndofs)
            R, l = elemGeom(mesh.nodesMat[nodeselem[1], :], mesh.nodesMat[nodeselem[2], :], ndofs)
            elemSecParams = section.params
            elemMaterial = material

            # Elem disps in local system
            UkeL = R' * Uk[elemdofs]

            # Internal force
            intBool = 0
            Finte, ~ = finte_KT_int(elemMaterial, l, elemSecParams, UkeL, intBool)

            # Stores & Assmebles Finte 
            FintkL[elemdofs] = Finte
            Fintk[elemdofs] = Fintk[elemdofs] + R * Finte

        end
    =#


    #return Uk, Fintk, FintkL, deltaUk
    return Uk, deltaUk


end