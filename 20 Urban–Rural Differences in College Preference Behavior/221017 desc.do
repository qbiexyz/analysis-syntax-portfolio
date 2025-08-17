*Last Update : 2022.10.17
*Filename : [rc_modeling][偏鄉]221017 desc
*Data:
*Subject:desc


cd "C:\Users\qbieqbiexyz\Desktop\rc"
******************************************************************************
sysdir set PLUS "D:\stata_pkgs\plus"

use "rc_data\tscs_lv7\analysis_clear_only_1017.dta",clear




desctab gsat_chigp_rc2 eng gsat_mathgp_rc2 gsat_socgp_rc2 gsat_scigp_rc2 ///
		i.ttscore_c2 i.fill6  i.allpub i.pub3 i.nocancel ///
        i.male i.lictyp i.retest i.chimiss i.engmiss i.mathmiss grade ///		
        i.rural_3  i.hscity4 i.sschpub i.hs_type ///
		i.ttscore_c i.allfill pub_PR i.choose i.rural_7 i.hscity, ///
		filename("C:\Users\qbieqbiexyz\Desktop\rc\rc_output\偏鄉\out1017_永健\des\output1017_all desc") ///
		stats(n freq  mean sd min max ) notesize(12) fontsize(12)  decimals(3)
		  
desctab gsat_chigp_rc2 eng gsat_mathgp_rc2 gsat_socgp_rc2 gsat_scigp_rc2 ///
		i.ttscore_c2 i.fill6  i.allpub i.pub3 i.nocancel ///
        i.male i.lictyp i.retest i.chimiss i.engmiss i.mathmiss grade ///		
        i.rural_3  i.hscity4 i.sschpub  ///
		i.ttscore_c i.allfill pub_PR i.choose i.rural_7 i.hscity, ///
	    filename("C:\Users\qbieqbiexyz\Desktop\rc\rc_output\偏鄉\out1017_永健\des\output1017_學校類型") ///
		stats(n freq mean sd min max) group(hs_type1) notesize(12) fontsize(12)  decimals(3)
		  
desctab gsat_chigp_rc2 eng gsat_mathgp_rc2 gsat_socgp_rc2 gsat_scigp_rc2 ///
		i.ttscore_c2 i.fill6  i.allpub i.pub3 i.nocancel ///
        i.male i.lictyp i.retest i.chimiss i.engmiss i.mathmiss grade ///		
        i.hscity4 i.sschpub i.hs_type ///
		i.ttscore_c i.allfill pub_PR i.choose i.hscity, ///
	    filename("C:\Users\qbieqbiexyz\Desktop\rc\rc_output\偏鄉\out1017_永健\des\output1017_偏鄉三類") ///
		stats(n freq mean sd min max) group(rural_3) notesize(12) fontsize(12)  decimals(3)
		  
desctab gsat_chigp_rc2 eng gsat_mathgp_rc2 gsat_socgp_rc2 gsat_scigp_rc2 ///
		i.ttscore_c2 i.fill6  i.allpub i.pub3 i.nocancel ///
        i.male i.lictyp i.retest i.chimiss i.engmiss i.mathmiss grade ///		
        i.hscity4 i.sschpub ///
		i.ttscore_c i.allfill pub_PR i.choose i.hscity if hs_type == 1, ///
		filename("C:\Users\qbieqbiexyz\Desktop\rc\rc_output\偏鄉\out1017_永健\des\output1017_偏鄉三類(只有純普高)") ///
		stats(n freq mean sd min max) group(rural_3 ) notesize(12) fontsize(12)  decimals(3) 