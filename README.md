# BatchFiles 

# Laptop-lid 
At work our Windows 7 laptops are set to sleep whenever the lid is closed. This is a security feature because we don't want someone to be on the road and simply close the laptop lid in a hurry, leaving it turned on and the user logged in. If the laptop sleeps there is an extra layer of security. 

That's fine and dandy except that when in office we would like users to be able to close the lid and not get it to sleep. 

See my blog post on how I achieve this: http://rakhesh.com/windows/changing-what-happens-with-a-laptop-lid-is-closed-depending-on-its-location/

# Profile-perms
Given a bunch of roaming profile folders, I want to add the Administrators group to the security ACLs so the admins can peek inside the profile. There's a GPO setting to do this, but it only works for profiles created *after* the setting is rolled out (see http://rakhesh.com/windows/roaming-profile-permissions-and-versions/). Not a problem, run the batch file and it should sort this for you. Makes use of the 'takeown.exe' and 'icacls.exe' commands (see http://rakhesh.com/windows/beware-of-takeown-and-recursively-operating/ for more details). 