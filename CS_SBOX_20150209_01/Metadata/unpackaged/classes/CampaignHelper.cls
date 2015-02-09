public with sharing class CampaignHelper
{
	
	public static Map<String, Campaign> GetCampaignMap()
	{
		List<Campaign> campList = [Select Id, Name from Campaign];
		
		Map<String, Campaign> campMap = new Map<String, Campaign>();
		
		if (campList != null && campList.size() > 0)
		{
			for (Campaign c : campList)
			{
				campMap.put(c.Name, c);
			}
		}
		
		return campMap;
	}
	
	public static Boolean DoesCampaignNameExist(Campaign camp, Map<String, Campaign> campMap)
	{
		if (campMap.containsKey(camp.Name))
		{
			Campaign c = campMap.get(camp.Name);
				
			if (c.Id != camp.Id)
			{
				return true;
			}
		}
		
		return false;
				
    }

}