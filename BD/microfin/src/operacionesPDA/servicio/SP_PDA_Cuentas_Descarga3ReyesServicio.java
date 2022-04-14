package operacionesPDA.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import operacionesPDA.beanWS.response.SP_PDA_Cuentas_DescargaResponse;
import operacionesPDA.dao.SP_PDA_Cuentas_Descarga3ReyesDAO;
import cuentas.bean.CuentasAhoBean;
 
public class SP_PDA_Cuentas_Descarga3ReyesServicio extends BaseServicio{

	SP_PDA_Cuentas_Descarga3ReyesDAO sP_PDA_Cuentas_Descarga3ReyesDAO = null;
	
	private SP_PDA_Cuentas_Descarga3ReyesServicio(){
		super();
	}
	
	
	public static interface Enum_Lis_CtaCreGrupoNoSoli{
		int cuentasws =1;      
	}
	
	/* lista cuentas para WS */
	public SP_PDA_Cuentas_DescargaResponse listaCuentasWS(int tipoLista){
		SP_PDA_Cuentas_DescargaResponse respuestaLista = new SP_PDA_Cuentas_DescargaResponse();			
		List listaCuentas;
		CuentasAhoBean cuentas;
		
		listaCuentas = sP_PDA_Cuentas_Descarga3ReyesDAO.listaCuentasWS(tipoLista);
		
		if(listaCuentas !=null){ 			
			try{
				for(int i=0; i<listaCuentas.size(); i++){	
					cuentas = (CuentasAhoBean)listaCuentas.get(i);
					
					respuestaLista.addCuentas(cuentas);
				}
				
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista Cuentas y/o Creditos para WS", e);
			}			
		}		
	 return respuestaLista;
	}

	public SP_PDA_Cuentas_Descarga3ReyesDAO getsP_PDA_Cuentas_Descarga3ReyesDAO() {
		return sP_PDA_Cuentas_Descarga3ReyesDAO;
	}

	public void setsP_PDA_Cuentas_Descarga3ReyesDAO(
			SP_PDA_Cuentas_Descarga3ReyesDAO sP_PDA_Cuentas_Descarga3ReyesDAO) {
		this.sP_PDA_Cuentas_Descarga3ReyesDAO = sP_PDA_Cuentas_Descarga3ReyesDAO;
	}
	
}
