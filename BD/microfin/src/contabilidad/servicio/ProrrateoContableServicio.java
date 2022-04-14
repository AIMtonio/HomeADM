package contabilidad.servicio;

import java.util.List;

import contabilidad.bean.ProrrateoContableBean;
import contabilidad.dao.ProrrateoContableDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ProrrateoContableServicio extends BaseServicio{
	ProrrateoContableDAO prorrateoContableDAO=null;
	
	public ProrrateoContableServicio(){
		super();
	}
	
	public static interface Enum_Tran_ProrrateoContable{
		int agregar = 1;
		int modificar = 2;	
	}
	public static interface Enum_Con_ProrrateoContable{
		int consultaMetodo = 1; 
	}
	public static interface Enum_List_ProrrateoContable{
		int listaMetodos = 1; 
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,ProrrateoContableBean prorrateoContableBean){
		MensajeTransaccionBean mensaje=null;
			switch(tipoTransaccion){
				case Enum_Tran_ProrrateoContable.agregar:
							mensaje=prorrateoContableDAO.alta(prorrateoContableBean);					
					break;
				case Enum_Tran_ProrrateoContable.modificar:
							mensaje=prorrateoContableDAO.modifica(prorrateoContableBean);
					break;
			}
		return mensaje;
	}
	
	public ProrrateoContableBean consulta(int tipoLista, ProrrateoContableBean prorrateoContableBean){
		ProrrateoContableBean prorrateoBean =	null;
		switch(tipoLista){
			case Enum_Con_ProrrateoContable.consultaMetodo:
					prorrateoBean=prorrateoContableDAO.consultaMetodo(tipoLista,prorrateoContableBean);				
			break;		
		}		
		return prorrateoBean;
	}
	
	public List lista(int tipoLista,ProrrateoContableBean prorrateoContableBean){
		List prorrateoLista=null;
		switch(tipoLista){
			case Enum_List_ProrrateoContable.listaMetodos :
					prorrateoLista=prorrateoContableDAO.listaPrincipal(tipoLista,prorrateoContableBean);
			break;
		}
		return prorrateoLista;
	}
	
	
	public void setProrrateoContableDAO(ProrrateoContableDAO prorrateoContableDAO) {
		this.prorrateoContableDAO = prorrateoContableDAO;
	}	
	public ProrrateoContableDAO getProrrateoContableDAO(){
		return prorrateoContableDAO;
	}
}
