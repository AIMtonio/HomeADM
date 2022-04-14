package ventanilla.servicio;

import java.util.List;
import cuentas.servicio.CuentasFirmaServicio.Enum_Con_CuentasFirma;
import ventanilla.bean.OpcionesPorCajaBean;
import ventanilla.dao.OpcionesPorCajaDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;

public class OpcionesPorCajaServicio extends BaseServicio{
	OpcionesPorCajaDAO opcionesPorCajaDAO = null;
			
	public OpcionesPorCajaServicio () {
		super();
		// TODO Auto-generated constructor stub
	}	
	public static interface Enum_Tra_OpcionPorCaja{
		int guardar =1;
	}
	
	public static interface Enum_Lis_OpcionesPorCaja {

		int combo = 1;		
		int comboReversas = 2;
		int reimpresionTicket	= 3;
		int listaGridOpe  = 4;
		int listaGridRev  = 5;
		int listaOpera	  = 6;
		int listaPLD      = 7;
		int listaSujetasPLD      = 8;

	}
	

	public static interface Enum_Con_OpcionesPorCaja {
		int principal = 1;			
	}
	
	public MensajeTransaccionBean grabaTransaccion(OpcionesPorCajaBean opcionesPorCajaBean, int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String cadena = "";
		String[] cadenaSplit;		
		String tipoCaja = opcionesPorCajaBean.getTipoCaja();		
		mensaje = opcionesPorCajaDAO.bajaOpcionesPorCaja(opcionesPorCajaBean);		
		if(mensaje.getNumero() == Constantes.ENTERO_CERO){		
			if( opcionesPorCajaBean.getListaOpciones() != null ){
				List<String> listaOpcionesPorCaja = opcionesPorCajaBean.getListaOpciones();
				if(!listaOpcionesPorCaja.isEmpty()){						
						cadena = listaOpcionesPorCaja.get(0);
						OpcionesPorCajaBean opcionesPorCaja = new OpcionesPorCajaBean();					
						if (!cadena.isEmpty()){
							cadenaSplit = cadena.split(",");
							for(int i=0; i<cadenaSplit.length; i++){
								opcionesPorCaja.setOpcionCajaID(cadenaSplit[i]);
								opcionesPorCaja.setTipoCaja(tipoCaja);
								mensaje = opcionesPorCajaDAO.altaOpcionesPorCaja( opcionesPorCaja, Enum_Tra_OpcionPorCaja.guardar);											
							}
						}				
				}
			}	
		}// si es exito
		return mensaje;
	}		
		
	public Object[] listaCombo(int tipoLista, OpcionesPorCajaBean opcionesCajaBean){
		
		List listaOpciones = null;
		switch (tipoLista) {
			case Enum_Lis_OpcionesPorCaja.combo:		
				listaOpciones= opcionesPorCajaDAO.listaComboOpciones(opcionesCajaBean,tipoLista);				
				break;	
			case Enum_Lis_OpcionesPorCaja.comboReversas:		
				listaOpciones= opcionesPorCajaDAO.listaComboOpciones(opcionesCajaBean,Enum_Lis_OpcionesPorCaja.comboReversas);
				break;	
			case Enum_Lis_OpcionesPorCaja.listaGridOpe:		
				listaOpciones= opcionesPorCajaDAO.listaComboOpciones(opcionesCajaBean,tipoLista);				
				break;
			case Enum_Lis_OpcionesPorCaja.listaGridRev:		
				listaOpciones= opcionesPorCajaDAO.listaComboOpciones(opcionesCajaBean,tipoLista);				
				break;	
			case Enum_Lis_OpcionesPorCaja.reimpresionTicket:
				listaOpciones= opcionesPorCajaDAO.listaComboOpciones(opcionesCajaBean,tipoLista);
				break;	
			case Enum_Lis_OpcionesPorCaja.listaPLD:
				listaOpciones= opcionesPorCajaDAO.listaComboOpciones(opcionesCajaBean,tipoLista);
				break;
			case Enum_Lis_OpcionesPorCaja.listaSujetasPLD:
				listaOpciones= opcionesPorCajaDAO.listaOpcionesSujetas(opcionesCajaBean,tipoLista);
				break;
		}		
		return listaOpciones.toArray();
	}
	
	public OpcionesPorCajaBean consulta(int tipoConsulta, OpcionesPorCajaBean opcionesPorCajaBean){
		OpcionesPorCajaBean opcionesPorCaja = null;
		switch(tipoConsulta){
			case Enum_Con_CuentasFirma.principal:
				opcionesPorCaja = opcionesPorCajaDAO.consultaPrincipal(opcionesPorCajaBean, Enum_Con_CuentasFirma.principal);
			break;
		}
		return opcionesPorCaja;
	}
	
	
	//---------------Getter y Setter-------------
	public OpcionesPorCajaDAO getOpcionesPorCajaDAO() {
		return opcionesPorCajaDAO;
	}

	public void setOpcionesPorCajaDAO(OpcionesPorCajaDAO opcionesPorCajaDAO) {
		this.opcionesPorCajaDAO = opcionesPorCajaDAO;
	}


}
