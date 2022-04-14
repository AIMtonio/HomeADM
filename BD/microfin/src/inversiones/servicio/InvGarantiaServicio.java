package inversiones.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import inversiones.bean.InvGarantiaBean;
import inversiones.dao.InvGarantiaDAO;

import java.util.ArrayList;
import java.util.List;
 
public class InvGarantiaServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	InvGarantiaDAO invGarantiaDAO = null;
	
	//---------- Constructor ------------------------------------------------------------------------
	public InvGarantiaServicio(){
		super();
	}
			
	public static interface Enum_Tra_InvGarantia {
		int alta			= 1;
		int actualizacion	= 2;
	}
	
	public static interface Enum_Act_InvGarantia {
		int eliminar		= 1;
		int liberar			= 2;
	}
	
	public static interface Enum_Con_InvGarantia {
		int garliqCubierta		= 1;
		int garCredInv			= 2;	/* Devuelve el total Garantizado por Credito solo por inversiones*/
		int garInv				= 3;	/* Devuelve el total Garantizado por Inversion*/
		int credito				= 4;	/* Devuelve el id de CREDITOINVGAR para validar que existe el credito en la tabla*/
		int inversion			= 5;	/* Devuelve el id de CREDITOINVGAR para validar que existe la inversion en la tabla */
		int creditoEstatus		= 6;	/* Devuelve el credito id si es que tiene un estatus parametrizado*/
	}
	
	public static interface Enum_Lis_InvGarantia {
		int principal		= 1;
		int asignaInv		= 2; // lista las inversiones asignadas a un credito
		int asignaCre		= 3; // lista los creditos asignados a una inversion se ocupa en la liberacion
		int creAutVigVenGar	= 4; // lista los creditos autorizados, vigentes o vencidos que tengan una inversion en garantia
		int inverGar		= 5; // lista las inversiones que esten respaldando a algun credito
		int asignaInvLib	= 6; // lista las inversiones asignadas a un credito se ocupa en la liberacion
	}
	
	//---------- Transacciones ------------------------------------------------------------------------
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, InvGarantiaBean invGarantiaBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case(Enum_Tra_InvGarantia.alta):
				mensaje = invGarantiaDAO.alta(invGarantiaBean, tipoTransaccion);
				break;
			case(Enum_Tra_InvGarantia.actualizacion):
				mensaje = actualizar(tipoActualizacion,invGarantiaBean);
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean actualizar(int tipoActualizacion, InvGarantiaBean invGarantiaBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoActualizacion){
			case(Enum_Act_InvGarantia.eliminar):
				mensaje = invGarantiaDAO.actualizar(invGarantiaBean, tipoActualizacion);
				break;
			case(Enum_Act_InvGarantia.liberar):
				ArrayList listaMovimientos = (ArrayList) listaGridInversionesEnGarantia(invGarantiaBean);
				mensaje = invGarantiaDAO.liberar(invGarantiaBean, tipoActualizacion,  listaMovimientos);
				break;
		}		
		return mensaje;		
	}

	public InvGarantiaBean consulta(int tipoConsulta, InvGarantiaBean invGarantiaBean){
		InvGarantiaBean invGarantia = null;
		switch(tipoConsulta){
			case(Enum_Con_InvGarantia.garliqCubierta):
				invGarantia = invGarantiaDAO.consultagarliqCubierta(invGarantiaBean);
				break;
			case(Enum_Con_InvGarantia.garCredInv):
				invGarantia = invGarantiaDAO.consultaTotalGarantizadoCreditoInversiones(invGarantiaBean, tipoConsulta);
				break;
			case(Enum_Con_InvGarantia.garInv):
				invGarantia = invGarantiaDAO.consultaTotalGarantizadoInversion(invGarantiaBean, tipoConsulta);
				break;
			case(Enum_Con_InvGarantia.credito):
				invGarantia = invGarantiaDAO.consultaCredito(invGarantiaBean, tipoConsulta);
				break;
			case(Enum_Con_InvGarantia.inversion):
				invGarantia = invGarantiaDAO.consultaInversion(invGarantiaBean, tipoConsulta);
				break;
			case(Enum_Con_InvGarantia.creditoEstatus):
				invGarantia = invGarantiaDAO.consultaCreditoEstatus(invGarantiaBean, tipoConsulta);
				break;
		}		
		return invGarantia;		
	}
	
	public List lista(int tipoLista, InvGarantiaBean invGarantiaBean){
		List inverLista = null;
		switch (tipoLista) {
	        case  Enum_Lis_InvGarantia.principal:
	        	inverLista = invGarantiaDAO.listaPrincipal(invGarantiaBean, tipoLista);
	        	break;
	        case  Enum_Lis_InvGarantia.asignaInv:
	        	inverLista = invGarantiaDAO.listaInverAsignadas(invGarantiaBean, tipoLista);
	        	break;
	        case  Enum_Lis_InvGarantia.asignaCre:
	        	inverLista = invGarantiaDAO.listaCreditosAsignados(invGarantiaBean, tipoLista);// lista los creditos asignados a una inversion se ocupa en la liberacion
	        	break;
	        case Enum_Lis_InvGarantia.creAutVigVenGar:
	        	inverLista = invGarantiaDAO.listaCreAutVigVenGar(invGarantiaBean, tipoLista);
	        	break;
	        case Enum_Lis_InvGarantia.asignaInvLib:
	        	inverLista = invGarantiaDAO.listaInverAsignadas(invGarantiaBean, Enum_Lis_InvGarantia.asignaInv); // no cambiar el enum
	        	break;
	        case Enum_Lis_InvGarantia.inverGar:
	        	inverLista = invGarantiaDAO.listaInversionesEnGarantia(invGarantiaBean, tipoLista); 
	        	break;
	        	
		}
		return inverLista;
	}
	
	
	// listas para comboBox en pantalla de inversion en garantia 
	public  Object[] listaCombo(int tipoLista,InvGarantiaBean invGarantiaBean ) {
		List listaInversionesGarantia = null;
		switch(tipoLista){
	        case  Enum_Lis_InvGarantia.principal:
	        	listaInversionesGarantia = invGarantiaDAO.listaPrincipal(invGarantiaBean, tipoLista);
	        	break;
		}
		return listaInversionesGarantia.toArray();	
	}
	
	// funcion para obtener en una lista las inversiones seleccionadas 
	public List listaGridInversionesEnGarantia(InvGarantiaBean invGarantiaBean){
		ArrayList listaDetalle = new ArrayList();
		try{
			List<String> listaCreditoInvGarID   = invGarantiaBean.getListaCreditoInvGarID();
			List<String> listaCheckLiberar		= invGarantiaBean.getListaCheckLiberar();
			InvGarantiaBean invGarantiaBeanGrid = null;
			if(!listaCreditoInvGarID.isEmpty()){ 
				int tamanio = listaCreditoInvGarID.size();
				for(int i=0; i<tamanio; i++){
					if(!listaCreditoInvGarID.get(i).equals("0")){
						invGarantiaBeanGrid = new InvGarantiaBean();
						System.out.println("listaCreditoInvGarID.get(i)"+listaCreditoInvGarID.get(i));
						invGarantiaBeanGrid.setCreditoInvGarID(listaCreditoInvGarID.get(i));
						listaDetalle.add(invGarantiaBeanGrid);
					}
				}
			}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de grid de movimientos", e);
		}
		return listaDetalle;
	}
	
	// ---------- Getter's y Setter's -----------------------------------------------------------------------
	public InvGarantiaDAO getInvGarantiaDAO() {
		return invGarantiaDAO;
	}
	public void setInvGarantiaDAO(InvGarantiaDAO invGarantiaDAO) {
		this.invGarantiaDAO = invGarantiaDAO;
	}		
}
