package operacionesPDA.servicio;

import java.util.List;
 
import operacionesPDA.beanWS.request.SP_PDA_Ahorros_DescargaRequest;
import operacionesPDA.beanWS.response.SP_PDA_Ahorros_DescargaResponse;
import operacionesPDA.dao.SP_PDA_Ahorro_Descarga3ReyesDAO;
import general.servicio.BaseServicio;
import cuentas.bean.CuentasAhoBean;

public class SP_PDA_Ahorros_Descarga3ReyesServicio extends BaseServicio {

	private SP_PDA_Ahorros_Descarga3ReyesServicio(){
		super();
	}

	SP_PDA_Ahorro_Descarga3ReyesDAO sp_PDA_Ahorro_Descarga3ReyesDAO = null;
	
	
	public static interface Enum_Lis_CuentasAhorroWS{
		int ahorroCuentas =1;      
	}

	
	/* lista cuentas de clientes que pertenecen a un promotor para WS */
	public SP_PDA_Ahorros_DescargaResponse listacuentasAhoWS(SP_PDA_Ahorros_DescargaRequest request){
		SP_PDA_Ahorros_DescargaResponse respuestaLista = new SP_PDA_Ahorros_DescargaResponse();			
		List listaCuentas;
		CuentasAhoBean cuentas;
		
		listaCuentas = sp_PDA_Ahorro_Descarga3ReyesDAO.listacuentasAhoWS(request,Enum_Lis_CuentasAhorroWS.ahorroCuentas);
		
		if(listaCuentas !=null){ 			
			try{
				for(int i=0; i<listaCuentas.size(); i++){	
					cuentas = (CuentasAhoBean)listaCuentas.get(i);
					
					respuestaLista.addCuenta(cuentas);
				}
				
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista Ahorros de cuentas para WS", e);
			}			
		}		
	 return respuestaLista;
	} // fin lista WS


	public SP_PDA_Ahorro_Descarga3ReyesDAO getSp_PDA_Ahorro_Descarga3ReyesDAO() {
		return sp_PDA_Ahorro_Descarga3ReyesDAO;
	}


	public void setSp_PDA_Ahorro_Descarga3ReyesDAO(
			SP_PDA_Ahorro_Descarga3ReyesDAO sp_PDA_Ahorro_Descarga3ReyesDAO) {
		this.sp_PDA_Ahorro_Descarga3ReyesDAO = sp_PDA_Ahorro_Descarga3ReyesDAO;
	}
	
}
