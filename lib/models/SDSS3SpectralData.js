(function() {
  var SDSS3SpectralData, Spine,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Spine = require('spine');

  SDSS3SpectralData = (function(_super) {

    __extends(SDSS3SpectralData, _super);

    function SDSS3SpectralData() {
      return SDSS3SpectralData.__super__.constructor.apply(this, arguments);
    }

    SDSS3SpectralData.configure('SDSS3SpectralData', 'wavelengths', 'spectrosynflux', 'petromagerr', 'psfflux', 'offsetdec', 'decerr', 'elodie_bv', 'rchi2', 'petroth50err', 'modelflux_ivar', 'colc', 'spectroflux_ivar', 'flags2', 'm_cr4', 'fracdev', 'objc_flags2', 'objc_type', 'spectro_class', 'rerun', 'colvdegerr', 'b', 'm_rr_ccerr', 'aperflux', 'ab_experr', 'ab_deverr', 'rchi2diff', 'tfile', 'api_id', 'colvdeg', 'z_person', 'star_lnl', 'wavemin', 'chi68p', 'petroth50', 'spectrumID', 'nmgypercount', 'fiber_number', 'spectrosynflux_ivar', 'petrothetaerr', 'fibermag', 'cmodelmag', 'aperflux_ivar', 'rowvdeg', 'vdisp', 'l', 'ifield', 'cx', 'nedge', 'mode', 'rest_frame_values', 'objc_prob_psf', 'skyversion', 'cloudcam', 'theta_exp', 'z_err', 'sn_median', 'petromag', 'fracnsighi', 'elodie_teff', 'inv_var', 'vdispdof', 'spectro_subclass', 'objc_colc', 'uerr', 'rowcerr', 'boss_target1', 'flux', 'psfflux_ivar', 'dev_lnl', 'filename', 'm_e2', 'm_e1', 'score', 'run', 'ra', 'elodie_rchi2', 'devmagerr', 'theta', 'petroth90err', 'elodie_filename', 'devmag', 'best_fit', 'm_e1e1err', 'psfmag', 'airmass', 'petrotheta', 'objc_flags', 'parent', 'fracnsiglo', 'offsetra', 'modelflux', 'm_rr_cc_psf', 'fiber2flux', 'spec2', 'colcerr', 'fiberflux', 'spec1', 'spectroflux', 'objc_rowcerr', 'skyflux', 'expmagerr', 'elodie_z_modelerr', 'ancillary_target1', 'ancillary_target2', 'ab_dev', 'anyormask', 'psf_fwhm', 'petroflux_ivar', 'resolve_status', 'exp_lnl', 'camcol', 'fieldid', 'phi_offset', 'phi_exp_deg', 'parentid', 'thing_id', 'petroflux', 'cz', 'cy', 'target_flags', 'objc_colcerr', 'extinction', 'modelmag', 'u', 'anyandmask', 'cmodelmagerr', 'raerr', 'rowvdegerr', 'pixscale', 'ndetect', 'elodie_feh', 'fibermagerr', 'wavemax', 'rowc', 'target_masks', 'nchild', 'ab_exp', 'type', 'or_mask', 'psfmagerr', 'calib_status', 'fiberflux_ivar', 'and_mask', 'm_e2_psf', 'elodie_logg', 'elodie_z_err', 'zwarning', 'fiber2flux_ivar', 'theta_deverr', 'devflux_ivar', 'z', 'm_e2e2err', 'm_e1_psf', 'vdispz', 'expflux', 'profmean_nmgy', 'spectroskyflux', 'fiber2magerr', 'petroth90', 'wcoverage', 'nmgypercount_ivar', 'theta_experr', 'dec', 'tcolumn', 'expmag', 'prob_psf', 'modelmagerr', 'z_conf_person', 'vdispchi2', 'phi_dev_deg', 'tai', 'cmodelflux_ivar', 'expflux_ivar', 'elodie_dof', 'wavelength_dispersion', 'proferr_nmgy', 'balkan_id', 'id', 'field', 'specprimary', 'cmodelflux', 'nobserve', 'fiber2mag', 'm_cr4_psf', 'rest_frame_wavelength_index', 'fracnsigma', 'elodie_object', 'qerr', 'skyflux_ivar', 'vdispnpix', 'psp_status', 'nprof', 'sky_flux', 'objid', 'objc_rowc', 'mjd', 'theta_dev', 'm_rr_cc', 'elodie_sptype', 'vdispz_err', 'devflux', 'dof', 'm_e1e2err', 'q', 'npoly', 'flags', 'clean', 'vdisp_err', 'objtype', 'elodie_z');

    SDSS3SpectralData.spectrumID = /(?:all|sdss|boss|apogee)\.\d{3,4}\.5\d{4}\.\d{1,3}\.(?:103|26|104|v5_4_45)?/;

    SDSS3SpectralData.fetch = function(sdssid) {
      var match, params;
      match = sdssid.match(SDSS3SpectralData.spectrumID);
      if (match == null) {
        alert('SDSS Spectral ID is malformed.');
        return null;
      }
      params = {
        url: "http://api.sdss3.org/spectrum?id=" + sdssid + "&format=json",
        success: SDSS3SpectralData.fromJSON
      };
      return $.ajax(params);
    };

    SDSS3SpectralData.fromJSON = function(json) {
      var item, key, value, _ref, _results;
      SDSS3SpectralData.lastFetch = new Array;
      _ref = json[0];
      _results = [];
      for (key in _ref) {
        value = _ref[key];
        item = SDSS3SpectralData.create(json[0][key]);
        _results.push(SDSS3SpectralData.lastFetch.push(item));
      }
      return _results;
    };

    return SDSS3SpectralData;

  }).call(this, Spine.Model);

  module.exports = SDSS3SpectralData;

}).call(this);
