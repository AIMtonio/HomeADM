package operacionesCRCB.servicio;

import java.util.List;


import operacionesCRCB.bean.ConMovimientosCuentaBean;
import operacionesCRCB.beanWS.request.ConMovimientosCuentaRequest;
import operacionesCRCB.beanWS.response.ConMovimientosCuentaResponse;
import operacionesCRCB.dao.ConMovimientosCuentaDAO;
import general.dao.BaseDAO;

public class ConMovimientosCuentaServicio extends BaseDAO{
	
	ConMovimientosCuentaDAO conMovimientosCuentaDAO = null;
	
	public ConMovimientosCuentaServicio (){
		super();
	}
	
	public static interface Enum_Lis_Cuenta{
		int movimientoCtas = 1;      
	}
	
	public ConMovimientosCuentaResponse consultaSaldoCuenta(ConMovimientosCuentaRequest requestBean){
		
		ConMovimientosCuentaResponse response = null;
		
		response = conMovimientosCuentaDAO.consultaSaldoWS(requestBean);

		return response;
	}
	
	/* Lista de Movimientos de Cuentas para WS */
	public ConMovimientosCuentaResponse listaMovimientoCtaWS(int tipoLista,ConMovimientosCuentaRequest bean){
		ConMovimientosCuentaResponse respuestaLista = new ConMovimientosCuentaResponse();			
		List listaMovimientoCta;
		ConMovimientosCuentaBean movimientosCuenta;
		switch (tipoLista) {
			case Enum_Lis_Cuenta.movimientoCtas:
				listaMovimientoCta = conMovimientosCuentaDAO.listaMovimientoCtaWS(tipoLista,bean);
			
				if(listaMovimientoCta !=null){ 			
					try{
						for(int i=0; i<listaMovimientoCta.size(); i++){	
							movimientosCuenta = (ConMovimientosCuentaBean)listaMovimientoCta.get(i);
							
							respuestaLista.addCuenta(movimientosCuenta);
						}
					}catch(Exception e){
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista movimientos cuentas para WS", e);
					}			
				}
			break;
		}
	 return respuestaLista;
	}
	
	
	// ========== GETTER & SETTER ============
	
	public ConMovimientosCuentaDAO getConMovimientosCuentaDAO() {
		return conMovimientosCuentaDAO;
	}

	public void setConMovimientosCuentaDAO(
			ConMovimientosCuentaDAO conMovimientosCuentaDAO) {
		this.conMovimientosCuentaDAO = conMovimientosCuentaDAO;
	}

}
