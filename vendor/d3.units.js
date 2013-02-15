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
    U: 'mag',
    G: 'mag',
    R: 'mag',
    I: 'mag',
    Z: 'mag',
    Ra: {
      label: 'RA',
      unit: 'º'
    },
    Dec: 'º',
    B: 'º',
    L: 'º',
    "PetroR90 U" : 'arcsec',
    "PetroR90 G" : 'arcsec',
    "PetroR90 R" : 'arcsec',
    "PetroR90 I" : 'arcsec',
    "PetroR90 Z" : 'arcsec',
    "Absolute Size" : 'mag',
    "PetroR50 R" : 'arcsec',
    "Abs R" : 'kpc',
    "Petrorad Flux" : '?'
  }
};