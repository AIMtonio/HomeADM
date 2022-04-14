
package regulatorios.servicio;
import general.servicio.BaseServicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import regulatorios.bean.RegulatorioInsBean;
import regulatorios.dao.RegulatorioInsDAO;


public class RegulatorioInsServicio  extends BaseServicio{
	RegulatorioInsDAO regulatorioInsDAO = null;	
	
	
	public RegulatorioInsServicio() {
		super();
	}

	public static interface Enum_Lis_TipoReporte{
		int excel = 1;
		int csv   = 2;
	}
	
	public static interface Enum_Lis_RegulatoriosIns{
		int regulatoriosIns	 = 2;
		int nivelOperaciones = 1;
		int nivelPrudencial  = 3;
		
	}
	
	/* ================== Tipo de Lista para reportes regulatorios ============== */
	public static interface Enum_Lis_TiposInstitucion{
		int bc	 			= 1;
		int bd		 		= 2;
		int sofipo		 	= 3;
		int sofom		 	= 4;
		int sofoles		 	= 5;
		int scap		 	= 6;
		int fideicomiso		= 7;
		
	}
	
	public static interface Enum_Con_RegulatoriosIns{
		int aplicaReg		= 1;

	}

	public RegulatorioInsBean consulta(int tipoConsulta, RegulatorioInsBean regulatorioBean){
		RegulatorioInsBean regulatorioInsBean = null;
		switch(tipoConsulta){
			case Enum_Con_RegulatoriosIns.aplicaReg:
				regulatorioInsBean = regulatorioInsDAO.consultaAplicaRegulatorio(regulatorioBean, Enum_Con_RegulatoriosIns.aplicaReg);
			break;
			
		}
		return regulatorioInsBean;
	}
	
	
	public List lista(int tipoLista,RegulatorioInsBean regulatorioBean){
		List listaInstituciones = null;
		switch(tipoLista){
			case Enum_Lis_RegulatoriosIns.regulatoriosIns:
				listaInstituciones = regulatorioInsDAO.listaInstitucionesReg(regulatorioBean, tipoLista);
			break;
			case Enum_Lis_RegulatoriosIns.nivelOperaciones:
				listaInstituciones = regulatorioInsDAO.listaNivelOperaciones(regulatorioBean, tipoLista);
			break;
			case Enum_Lis_RegulatoriosIns.nivelPrudencial:
				listaInstituciones = regulatorioInsDAO.listaNivelPrudencial(regulatorioBean, tipoLista);
			break;
			
		}
		
		return listaInstituciones;
	}
	
	
	public static String descripcionMes(String meses){
		String mes = "";
		int mese = Integer.parseInt(meses);
        switch (mese) {
            case 1:  mes ="ENERO" ; break;
            case 2:  mes ="FEBRERO"; break;
            case 3:  mes ="MARZO"; break;
            case 4:  mes ="ABRIL"; break;
            case 5:  mes ="MAYO"; break;
            case 6:  mes ="JUNIO"; break;
            case 7:  mes ="JULIO"; break;
            case 8:  mes ="AGOSTO"; break;
            case 9:  mes ="SEPTIEMBRE"; break;
            case 10: mes ="OCTUBRE"; break;
            case 11: mes ="NOVIEMBRE"; break;
            case 12: mes ="DICIEMBRE"; break;
        }
        return mes;
	}
	
	
	
	/* ========================= GET  &&  SET  =========================*/
	
	public RegulatorioInsDAO getRegulatorioInsDAO() {
		return regulatorioInsDAO;
	}


	public void setRegulatorioInsDAO(RegulatorioInsDAO regulatorioInsDAO) {
		this.regulatorioInsDAO = regulatorioInsDAO;
	}	
	



		
}
