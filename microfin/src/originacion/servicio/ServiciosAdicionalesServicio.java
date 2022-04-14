package originacion.servicio;

import java.util.ArrayList;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import originacion.bean.ServiciosAdicionalesBean;
import originacion.dao.ServiciosAdicionalesDAO;

public class ServiciosAdicionalesServicio extends BaseServicio {
	
	ServiciosAdicionalesDAO serviciosAdicionalesDAO = null;

	public ServiciosAdicionalesServicio() {
		super();
	}

	public static interface Enum_Tra_ServiciosAdicionales {
		int alta = 1;
		int modifica = 2;
		int baja = 3;
	}

	public static interface Enum_Con_ServiciosAdicionales {
		int principal = 1;
		int validaInstitNomina = 3;
	}
	
	public static interface Enum_Lista_ServiciosAdicionales {
		int principal = 1;
		int producto = 2; //Consulta de servicios adicionales por producto nomina o privado
		int institNomina = 3;
	}

	public MensajeTransaccionBean grabaTransaccion(ServiciosAdicionalesBean serviciosAdicionalesBean, int tipoTransaccion) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_ServiciosAdicionales.alta:
			eliminarCeroDeListas(serviciosAdicionalesBean);
			mensaje = serviciosAdicionalesDAO.altaServiciosAdicionales(serviciosAdicionalesBean);
			break;
		case Enum_Tra_ServiciosAdicionales.modifica:
			eliminarCeroDeListas(serviciosAdicionalesBean);
			mensaje = serviciosAdicionalesDAO.modificaServiciosAdicionales(serviciosAdicionalesBean);
			break;
		case Enum_Tra_ServiciosAdicionales.baja:
			mensaje = serviciosAdicionalesDAO.baja(serviciosAdicionalesBean);
			break;
		}
		
		return mensaje;
	}
	
	private void eliminarCeroDeListas(ServiciosAdicionalesBean serviciosAdicionalesBean) {
		List newListaProductosCreditos = new ArrayList();
		List<Integer> listaProductosCreditos = serviciosAdicionalesBean.getProducCreditoID();
		if(listaProductosCreditos != null) {
			for (Integer integer : listaProductosCreditos) {
				if(integer > 0) {
					newListaProductosCreditos.add(integer);
				}
			}
		}
		serviciosAdicionalesBean.setProducCreditoID(newListaProductosCreditos);
		
		List newListaEmpresas = new ArrayList();
		List<Integer> listaEmpresas = serviciosAdicionalesBean.getInstitNominaID();
		if (listaEmpresas != null) {
			for (Integer integer : listaEmpresas) {
				if(integer > 0) {
					newListaEmpresas.add(integer);
				}
			}
		}
		serviciosAdicionalesBean.setInstitNominaID(newListaEmpresas);
	}

	/**
	 * Metodo para consultar las diferentes listas
	 * @param instance Modelo requerido
	 * @param tipoLista Tipo de Transaccion
	 * @return List Retorna una lista de resultado
	 */
	public List lista(ServiciosAdicionalesBean instance, int tipoLista){
		List lista = null;
		switch (tipoLista) {
			case Enum_Lista_ServiciosAdicionales.principal:
				lista = serviciosAdicionalesDAO.listaPrincipal(instance,tipoLista);
				break;
			case Enum_Lista_ServiciosAdicionales.producto:
				lista = serviciosAdicionalesDAO.listaServiciosAdicionales(tipoLista, instance);
				break;
			case Enum_Lista_ServiciosAdicionales.institNomina:
				lista = serviciosAdicionalesDAO.listaInstitNomina(instance,tipoLista);
				break;	
			
		}
		return lista;
	}
	
	/**
	 * Metodo para consultar las diferentes listas
	 * @param instance Modelo requerido
	 * @param tipoLista Tipo de Transaccion
	 * @return List Retorna una lista de resultado
	 */
	public ServiciosAdicionalesBean consulta(ServiciosAdicionalesBean instance, int tipoLista){
		ServiciosAdicionalesBean serviciosAdicionalesBean = null;
		switch (tipoLista) {
			case Enum_Con_ServiciosAdicionales.principal:
				serviciosAdicionalesBean = serviciosAdicionalesDAO.consultaPrincipal(instance,tipoLista);
				break;
			case Enum_Con_ServiciosAdicionales.validaInstitNomina:
				serviciosAdicionalesBean = serviciosAdicionalesDAO.consultaValidaInstitNomina(instance,tipoLista);
				break;
		}
		return serviciosAdicionalesBean;
	}
	
	public List obtenerListaDesdeCadena(String cadena) {
		List lista = new ArrayList();
		if(!cadena.isEmpty()) {
			String[] arr = cadena.split(",");
			for (int i = 0; i < arr.length; i++) {
				lista.add(Integer.valueOf(arr[i]));
			}
		}
		return lista;
	}

	public  Object[] listaCombo(int tipoLista) {
		List listaServiciosAdicionales = null;
		switch(tipoLista){
			case Enum_Lista_ServiciosAdicionales.principal:
			listaServiciosAdicionales = serviciosAdicionalesDAO.listaComboServiciosAdicionales(tipoLista);
			break;
		}
		return 	listaServiciosAdicionales.toArray();	
	}
	// getters y setters
	public ServiciosAdicionalesDAO getServiciosAdicionalesDAO() {
		return serviciosAdicionalesDAO;
	}

	public void setServiciosAdicionalesDAO(ServiciosAdicionalesDAO serviciosAdicionalesDAO) {
		this.serviciosAdicionalesDAO = serviciosAdicionalesDAO;
	}
}