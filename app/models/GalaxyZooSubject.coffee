Subject = require("zooniverse/lib/models/subject")
Config = require("lib/config")

class GalaxyZooSubject extends Subject
  @configure 'GalaxyZooSubject', "location", "metadata", "coords", "zooniverse_id"
  projectName: 'galaxy_zoo'
  
  @url: (params) -> @withParams "/projects/galaxy_zoo/groups/50251c3b516bcb6ecb000002/subjects", params


module.exports = GalaxyZooSubject