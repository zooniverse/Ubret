Utilities =
  equatorial2galactic: (ra, dec, epoch) ->
    d2r = Math.PI / 180
  
    OB = 23.4333334 * d2r
    dec *= d2r
    ra *= d2r
    a = (if (epoch and (epoch is "1950" or epoch is "B1950" or epoch is "FK4")) then 27.4 else 27.128251) # The RA of the North Galactic Pole
    d = (if (epoch and (epoch is "1950" or epoch is "B1950" or epoch is "FK4")) then 192.25 else 192.859481) # The declination of the North Galactic Pole
    l = (if (epoch and (epoch is "1950" or epoch is "B1950" or epoch is "FK4")) then 33.0 else 32.931918) # The ascending node of the Galactic plane on the equator
    sdec = Math.sin(dec)
    cdec = Math.cos(dec)
    sa = Math.sin(a * d2r)
    ca = Math.cos(a * d2r)
    GT = Math.asin(cdec * ca * Math.cos(ra - d * d2r) + sdec * sa)
    GL = Math.atan((sdec - Math.sin(GT) * sa) / (cdec * Math.sin(ra - d * d2r) * ca)) / d2r
    TP = sdec - Math.sin(GT) * sa
    BT = cdec * Math.sin(ra - d * d2r) * ca
    GL = GL + 360  if TP < 0  unless BT < 0
    GL = GL + l
    GL = GL - 360  if GL > 360
    LG = Math.floor(GL)
    LM = Math.floor((GL - Math.floor(GL)) * 60)
    LS = ((GL - Math.floor(GL)) * 60 - LM) * 60
    GT = GT / d2r
    D = Math.abs(GT)
    if GT > 0
      BG = Math.floor(D)
    else
      BG = (-1) * Math.floor(D)
    BM = Math.floor((D - Math.floor(D)) * 60)
    BS = ((D - Math.floor(D)) * 60 - BM) * 60
    if GT < 0
      BM = -BM
      BS = -BS
  
    return {l: GL, b: GT}

module.exports = Utilities