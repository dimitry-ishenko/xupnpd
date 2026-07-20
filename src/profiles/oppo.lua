profiles['OPPO']=
{
    ['desc']='OPPO Bluray Player',
    ['match']=function(user_agent) return string.find(user_agent, '^OPPO PLAYER') ~= nil end,
}
