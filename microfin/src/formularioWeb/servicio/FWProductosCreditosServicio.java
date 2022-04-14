package formularioWeb.servicio;

import java.util.List;


import formularioWeb.bean.FWProductosCreditoBean;
import formularioWeb.bean.FwListaProductosCreditoBean;
import formularioWeb.bean.FwProductoCreditoBean;
import formularioWeb.dao.FWProductosDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;
import herramientas.mapeaBean;

public class FWProductosCreditosServicio extends BaseServicio {

	private FWProductosDAO fwProductosDAO = null;
	
	public static interface Enum_Tra_Productos {
		int modificacion = 1;
	}
	
	public static interface Enum_Lis_ProductosCreditos {
		int principal = 3;
	}
	
	/**
	 * Metodo para el acceso a datos de lista
	 * @param tipoLista
	 * @return
	 */
	public List<?> lista(int tipoLista) {
		
		List<?> listaResult = null;
		
		switch (tipoLista) {
			case Enum_Lis_ProductosCreditos.principal:{
				FwListaProductosCreditoBean banListaProductosCreditoBean = new FwListaProductosCreditoBean();
				banListaProductosCreditoBean = (FwListaProductosCreditoBean) mapeaBean.valoresDefaultABean(banListaProductosCreditoBean);
				banListaProductosCreditoBean.setNumLis(Integer.toString(Enum_Lis_ProductosCreditos.principal));
				listaResult = fwProductosDAO.listaProductoCreditoFw(banListaProductosCreditoBean);
				break;
			}
		}
		return listaResult;
	}
	
	/**
	 * Metodo transaccion del servicio.
	 * @param numeroProceso -> {@link Integer}
	 * @param beanEntrada -> {@link Object}
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean grabaTransaccion(int numeroProceso, Object beanEntrada) {
		
		MensajeTransaccionBean mensajeTransaccionBean = null;
		
		switch(numeroProceso) {
			case Enum_Tra_Productos.modificacion :{
				
				FWProductosCreditoBean entrada = (FWProductosCreditoBean) beanEntrada;
				mensajeTransaccionBean = this.modificaProductos(entrada);
				
				return mensajeTransaccionBean;
			}
			
		}
		return mensajeTransaccionBean;
	}
	
	/**
	 * Metodo que realiza la actualizacion de productos de credito de formulario web.
	 * @param parametros -> {@link FWProductosCreditoBean}
	 * @return {@link MensajeTransaccionBean}
	 */
	private MensajeTransaccionBean modificaProductos(final FWProductosCreditoBean parametros) {
		
		MensajeTransaccionBean mensaje = null;
		
		try {
			FwProductoCreditoBean fwProductoCreditoBean = new FwProductoCreditoBean(); 
			fwProductoCreditoBean.setProductoCreditoFWIDs(parametros.getProductoCreditoFWIDs());
			mensaje = this.fwProductosDAO.eliminaProductosCreditoFw(fwProductoCreditoBean);
			
			if(!(mensaje.getNumero() == Utileria.convierteEntero(Constantes.STR_CODIGOEXITO[0]))) {
				throw new Exception(mensaje.getDescripcion());
			}

			if (!parametros.getLisProducCredito().isEmpty()) {

				String idProducto = "";
				String destinoCreditoId = "";
				String clasificacionDestino = "";
				String productoCreditoFWID = "";

				FwProductoCreditoBean banProductosCreditoBean = null;
				for (int i = 0; i < parametros.getLisProducCredito().size(); i++) {
					idProducto = (String) parametros.getLisProducCredito().get(i);
					destinoCreditoId = (String) parametros.getLisDestinoCredito().get(i);
					clasificacionDestino = (String) parametros.getLisClasificacion().get(i);
					productoCreditoFWID = (String)(parametros.getLisProductoCreditoFWID().get(i) == null?0:parametros.getLisProductoCreditoFWID().get(i));

					banProductosCreditoBean = new FwProductoCreditoBean();
					banProductosCreditoBean.setProductoCreditoFWID(productoCreditoFWID);
					banProductosCreditoBean.setProductoCreditoID(idProducto);
					banProductosCreditoBean.setDestinoCreditoID(destinoCreditoId);
					banProductosCreditoBean.setClasificacionDestino(clasificacionDestino);
					banProductosCreditoBean.setPerfilID(String.valueOf(Constantes.ENTERO_UNO));
					
					mensaje = this.fwProductosDAO.altaProductosCreditoFw(banProductosCreditoBean);
					
					if(!(mensaje.getNumero() == Utileria.convierteEntero(Constantes.STR_CODIGOEXITO[0]))) {
						throw new Exception(mensaje.getDescripcion());
					}
					
				}

			}
			
			if (mensaje != null) {
				mensaje.setDescripcion("Parametros Modificados Exitosamente.");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(999);
			mensaje.setDescripcion(e.getMessage());
		}
		
		return mensaje;
	}

	public FWProductosDAO getFwProductosDAO() {
		return fwProductosDAO;
	}


	public void setFwProductosDAO(FWProductosDAO fwProductosDAO) {
		this.fwProductosDAO = fwProductosDAO;
	}
	
}
