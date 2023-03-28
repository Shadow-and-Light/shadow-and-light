# Lib: Processable

## [61](https://github.com/p3lim-wow/LibProcessable/tree/61) (2023-03-02)
[Full Changelog](https://github.com/p3lim-wow/LibProcessable/commits/61) [Previous Releases](https://github.com/p3lim-wow/LibProcessable/releases)

- Update MINOR  
- Support disenchanting Sophic Amalgamation  
- Add support for engineering scrapping  
- Update crafting API notes  
- Update Interface version (#57)  
    Co-authored-by: p3lim <p3lim@users.noreply.github.com>  
- Update license (#56)  
    Co-authored-by: p3lim <p3lim@users.noreply.github.com>  
- Update version  
- Fix incorrect return  
- Update version  
- Add more disenchantable items  
- Update version  
- Add support for disenchanting profession equipment  
    Fixes p3lim-wow/Molinari#81  
- Add special disenchantable items in Dragonflight  
    Fixes p3lim-wow/Molinari#80  
- Update Interface version (#55)  
    Co-authored-by: p3lim <p3lim@users.noreply.github.com>  
- Fix lint errors  
- Update version  
- Update Interface version  
- Fix missing rank info  
- Slightly improve upon expansion specific skill level detection  
    This is far from perfect, but we can check early (and without player  
    intervention) if milling and/or prospecting spells are known.  
- Track TRADE\_SKILL\_SHOW and add note about issues  
- Support dragonflight milling and prospecting spells  
    These are divided by expansion, e.g. you can only prospect legion ores  
    using legion prospecting.  
- Fix action output deprecation  
- Documentation touchups  
- Don't populate classic profession table unless necessary  
    Also using new constants  
- Define constants for the profession IDs  
    This should also pass luacheck  
- Partial lint pass  
- Bump actions/checkout from 2 to 3 (#52)  
    Bumps [actions/checkout](https://github.com/actions/checkout) from 2 to 3.  
    - [Release notes](https://github.com/actions/checkout/releases)  
    - [Changelog](https://github.com/actions/checkout/blob/main/CHANGELOG.md)  
    - [Commits](https://github.com/actions/checkout/compare/v2...v3)  
    ---  
    updated-dependencies:  
    - dependency-name: actions/checkout  
      dependency-type: direct:production  
      update-type: version-update:semver-major  
    ...  
    Signed-off-by: dependabot[bot] <support@github.com>  
    Signed-off-by: dependabot[bot] <support@github.com>  
    Co-authored-by: dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>  
- Bump actions/upload-artifact from 2 to 3 (#53)  
    Bumps [actions/upload-artifact](https://github.com/actions/upload-artifact) from 2 to 3.  
    - [Release notes](https://github.com/actions/upload-artifact/releases)  
    - [Commits](https://github.com/actions/upload-artifact/compare/v2...v3)  
    ---  
    updated-dependencies:  
    - dependency-name: actions/upload-artifact  
      dependency-type: direct:production  
      update-type: version-update:semver-major  
    ...  
    Signed-off-by: dependabot[bot] <support@github.com>  
    Signed-off-by: dependabot[bot] <support@github.com>  
    Co-authored-by: dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>  
- Bump peter-evans/create-pull-request from 3 to 4 (#54)  
    Bumps [peter-evans/create-pull-request](https://github.com/peter-evans/create-pull-request) from 3 to 4.  
    - [Release notes](https://github.com/peter-evans/create-pull-request/releases)  
    - [Commits](https://github.com/peter-evans/create-pull-request/compare/v3...v4)  
    ---  
    updated-dependencies:  
    - dependency-name: peter-evans/create-pull-request  
      dependency-type: direct:production  
      update-type: version-update:semver-major  
    ...  
    Signed-off-by: dependabot[bot] <support@github.com>  
    Signed-off-by: dependabot[bot] <support@github.com>  
    Co-authored-by: dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>  
- Run luacheck on pushes  
- Use dependabot to update workflows  
- Update version  
- Update Interface version (#51)  
    Co-authored-by: p3lim <p3lim@users.noreply.github.com>  
- Fix for invalid professions on classic  
- Drop duplicate classic checks  
- Add check for classic/tbc/wrath professions  
    They don't have any of the tradeskill API.  
    Ref p3lim-wow/Molinari#67  
- Update README  
- Lint pass  
- Add preliminary support for Dragonflight  
- Add support for Kevin's Keyring  
- Add support for wrath  
    Ref p3lim-wow/Molinari#67  
- Update IsMillable docs to match signature  
- Use skill level to determine prospectable state  
- Use skill level to determine millable state  
- Fix laestrite skeleton key lockpick level  
- Fix inscription item lockpick level  
- Use skill level to check if the item can be opened  
    This changes the signature of IsOpenableProfession  
- Gather skill levels on both classic and retail  
    Fixes #14  
- Expose profession skill lines  
    These will come in handy later  
- Add note on how we gather the profession categories  
- Merge the data tables and use expansion enums  
- Key profession categories using existing enums  
- Make data private to avoid manipulation  
- Added skill for inscription in for Classic (#50)  
- Update Interface version (#49)  
    Co-authored-by: p3lim <p3lim@users.noreply.github.com>  
- Don't load libs in dev  
- Update version  
- Bump packager, dropping specific game versions  
- Use multitoc only, and update suffixes  
- Update Interface version (#48)  
    Co-authored-by: p3lim <p3lim@users.noreply.github.com>  
- Update Interface version (#47)  
    Co-authored-by: p3lim <p3lim@users.noreply.github.com>  
- Update Interface version (#44)  
    Co-authored-by: p3lim <p3lim@users.noreply.github.com>  
- Update license (#46)  
    Co-authored-by: p3lim <p3lim@users.noreply.github.com>  
- Update version  
- Add 9.2 items  
- Add lockboxes added in 9.1  
- Shadowlands lockboxes were renamed at some point  
- Fix ID for Tiny Titanium Lockbox  
    Fixes #45  
- Update tag  
- Update Interface version (#43)  
    Co-authored-by: p3lim <p3lim@users.noreply.github.com>  
- Update Interface version (#42)  
    Co-authored-by: p3lim <p3lim@users.noreply.github.com>  
- We no longer need to authenticate to use the version action  
- Update Interface version (#41)  
    Co-authored-by: p3lim <p3lim@users.noreply.github.com>  
- Update tag  
- Fix matching against shirts  
- Fix matching against 2h maces  
- Update version update workflow  
- Update version  
- Split TOC files and update release workflow  
- Update Interface version (#38)  
    Co-authored-by: p3lim <p3lim@users.noreply.github.com>  
- Fix sparse changelogs on releases  
- Update version  
- Create a valid index on classic when jewelcraft doesn't exist  
    Fixes p3lim-wow/Molinari#55  
- Update workflows and add BCC  
- Update version  
- Add BCC prospecting support and update lockboxes  
- Update Classic Interface version  
    # Conflicts:  
    #	LibProcessable.toc  
- Add BCC support  
- Update Interface version (#37)  
    Co-authored-by: p3lim <p3lim@users.noreply.github.com>  
- Update workflows  
- Update Interface version layout  
- Shirts and cosmetics cannot be disenchanted  
- Update license (#36)  
    Co-authored-by: p3lim <p3lim@users.noreply.github.com>  
- Update version  
- Add support for disenchanting Shadowlands profession world quest items  
- Update version  
- Update Interface version  
- Make sure the item is valid  
    Fixes #35  
- Update version  
- Add all lockboxes, regardless of availability  
    Some thought to be unobtainable are still being found by players,  
    so just add them all to be safe.  
    Also sorted the list.  
    Fixes p3lim-wow/Molinari#47  
