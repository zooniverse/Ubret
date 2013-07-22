d3.units = function (type) {
  function units(label) {
    try {
      unit = d3.units.lookup[type][label];
      if (typeof unit != 'string') {
        label = unit.label;
        unit = unit.unit;
      }
      return (label + ' (' + unit + ')');
    } catch (e) {
      return label;
    }
  }
  return units
}

d3.units.lookup = {
  astro: {
    U: {
      label: 'u',
      unit: 'mag'
    },
    G: {
      label: 'g',
      unit: 'mag'
    },
    R: {
      label: 'r',
      unit: 'mag'
    },
    I: {
      label: 'i',
      unit: 'mag'
    },
    Z: {
      label: 'z',
      unit: 'mag'
    },
    Ra: {
      label: 'RA',
      unit: 'deg'
    },
    Dec: 'deg',
    B: 'deg',
    L: 'deg',
    "PetroR90 U" : {
      label: "PetroR90 u",
      unit: 'arcsec'
    },
    "PetroR90 G" : {
      label: "PetroR90 g",
      unit: 'arcsec'
    },
    "PetroR90 R" : {
      label: "PetroR90 r",
      unit: 'arcsec'
    },
    "PetroR90 I" : {
      label: "PetroR90 i",
      unit: 'arcsec'
    },
    "PetroR90 Z" : {
      label: "PetroR90 z",
      unit: 'arcsec'
    },
    "Absolute Size" : 'kpc',
    "PetroR50 R" : {
      label: "PetroR50 r",
      unit: 'arcsec'
    },
    "Abs R" : 'mpg',
    "Petrorad Flux" : '?'
  }
};