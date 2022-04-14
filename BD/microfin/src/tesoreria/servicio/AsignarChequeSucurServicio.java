package tesoreria.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import tesoreria.bean.AsignarChequeSucurBean;
import tesoreria.dao.AsignarChequeSucurDAO;

public class AsignarChequeSucurServicio extends BaseServicio{
	AsignarChequeSucurDAO asignarChequeSucurDAO=null;
	
	public AsignarChequeSucurServicio(){
		super();
	}
	public static interface Enum_Transaccion_Chequera {
		int asigna=1;
	}
	public static interface Enum_Lis_Chequera {
		int principal = 1;
		int combo = 2;
		int grid = 8;
		int foranea = 4;
		int cuentasConChequera =6;
		int chequerasPorSucursal = 7;
	}
	public static interface Enum_Con_Chequera {
		int cuentaCheques=1;
		int folioUtilizar=2;
		int existenciaFolio=3;
		int consultafolioxBloqueCheques= 4;
	}
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,AsignarChequeSucurBean asignarChequeSucurBean){
		MensajeTransaccionBean mensaje=null;
		switch(tipoTransaccion){
			case Enum_Transaccion_Chequera.asigna:								
					mensaje=asignarChequeSucurDAO.asignaChequesSucur(asignarChequeSucurBean);
				break;
		}		
		return mensaje;
	}
	
	public Object[] listaCombo(int tipoLista, AsignarChequeSucurBean asignarCheque){
		List asignarChequeLista=null;
				switch(tipoLista){
				case Enum_Lis_Chequera.combo:					
					asignarChequeLista=asignarChequeSucurDAO.ChequeCombo(tipoLista,asignarCheque);
					break;
				}
		return asignarChequeLista.toArray();
	}
	
	public AsignarChequeSucurBean consulta(int tipoLista, AsignarChequeSucurBean asignarCheque){
		AsignarChequeSucurBean asignarChequeBean=null;
		switch (tipoLista) {
			case Enum_Con_Chequera.folioUtilizar:
				asignarChequeBean = asignarChequeSucurDAO.consultaUltimoFolio(tipoLista, asignarCheque);
				break;
			case Enum_Con_Chequera.existenciaFolio:
				asignarChequeBean = asignarChequeSucurDAO.consultaExisteFolio(tipoLista, asignarCheque);
				break;
			case Enum_Con_Chequera.consultafolioxBloqueCheques:
				asignarChequeBean = asignarChequeSucurDAO.consultafolioxBloqueCheques(tipoLista, asignarCheque);
				break;
		}
		return asignarChequeBean;
	}
	// Lista de cuentas que manejan chequera, filtra por sucursal, caja, institucion 
	public List listaCuentasConChequera(int tipoLista, AsignarChequeSucurBean asignarChequeSucurBean){		
		List listaCancelacionCheques = null;
		switch (tipoLista) {
			case Enum_Lis_Chequera.cuentasConChequera:		
				listaCancelacionCheques = asignarChequeSucurDAO.listaCuentas(asignarChequeSucurBean, tipoLista);				
				break;
			case Enum_Lis_Chequera.chequerasPorSucursal:					
				listaCancelacionCheques=asignarChequeSucurDAO.listaChequerasPorSucursal(asignarChequeSucurBean,tipoLista);
				break;
		}	
		return listaCancelacionCheques;
	}	
	
	public AsignarChequeSucurDAO getAsignarChequeSucurDAO() {
		return asignarChequeSucurDAO;
	}
	public void setAsignarChequeSucurDAO(AsignarChequeSucurDAO asignarChequeSucurDAO) {
		this.asignarChequeSucurDAO = asignarChequeSucurDAO;
	}
	
}
