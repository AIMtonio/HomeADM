package bancaMovil.servicio;

import bancaMovil.bean.BAMParametrosBean;
import bancaMovil.bean.BanProductosCreditoBean;
import bancaMovil.bean.BanTiposCuentaBean;
import bancaMovil.dao.BAMParametrosDAO;
import bancaMovil.dao.BANProductoCreditoBeDAO;
import bancaMovil.dao.BANTiposCuentasDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

public class BAMParametrosServicio extends BaseServicio {
	
	private BAMParametrosDAO parametrosDAO = null;
	private BANProductoCreditoBeDAO banProductoCreditoBeDAO = null;
	private BANTiposCuentasDAO banTiposCuentasDAO = null;
	
	public static interface Enum_Act_Parametros {
		int principal = 1;
	}

	public static interface Enum_Con_Parametros {
		int principal = 1;
		int activacionMensaje = 2;
		int rutaKtr = 3;
	}

	public static interface Enum_Tra_Parametros {
		int modificacion = 1;
	}

	public BAMParametrosServicio() {
		super();
	}
	
	public MensajeTransaccionBean grabaTransaccion(int numeroProceso, Object beanEntrada) {
		MensajeTransaccionBean mensajeTransaccionBean = null;
		
		switch(numeroProceso) {
			case Enum_Tra_Parametros.modificacion :{
				
				BAMParametrosBean entrada = (BAMParametrosBean) beanEntrada;
				mensajeTransaccionBean = modificaParametros(entrada);
				
				return mensajeTransaccionBean;
			}
			
		}
		return mensajeTransaccionBean;
	}

	private MensajeTransaccionBean modificaParametros(final BAMParametrosBean parametros) {
		MensajeTransaccionBean mensaje = null;
		
		try {
			
			mensaje = parametrosDAO.modificaParametros(parametros);
			
			if(!(mensaje.getNumero() == Utileria.convierteEntero(Constantes.STR_CODIGOEXITO[0]))) {
				throw new Exception(mensaje.getDescripcion());
			}
			
			mensaje = banProductoCreditoBeDAO.eliminaProductosCreditoBe(new BanProductosCreditoBean());
			
			if(!(mensaje.getNumero() == Utileria.convierteEntero(Constantes.STR_CODIGOEXITO[0]))) {
				throw new Exception(mensaje.getDescripcion());
			}

			if (!parametros.getLisProducCredito().isEmpty()) {

				String idProducto = "";
				String destinoCreditoId = "";
				String clasificacionDestino = "";

				BanProductosCreditoBean banProductosCreditoBean = null;
				
				for (int i = 0; i < parametros.getLisProducCredito().size(); i++) {
					idProducto = (String) parametros.getLisProducCredito().get(i);
					destinoCreditoId = (String) parametros.getLisDestinoCredito().get(i);
					clasificacionDestino = (String) parametros.getLisClasificacion().get(i);

					banProductosCreditoBean = new BanProductosCreditoBean();
					banProductosCreditoBean.setProductoCreditoID(idProducto);
					banProductosCreditoBean.setDestinoCreditoID(destinoCreditoId);
					banProductosCreditoBean.setClasificacionDestino(clasificacionDestino);
					banProductosCreditoBean.setPerfilID(parametros.getPerfil());
					
					mensaje = banProductoCreditoBeDAO.altaProductosCreditoBe(banProductosCreditoBean);
					
					if(!(mensaje.getNumero() == Utileria.convierteEntero(Constantes.STR_CODIGOEXITO[0]))) {
						throw new Exception(mensaje.getDescripcion());
					}
					
				}

			}
			
			mensaje = banTiposCuentasDAO.bajaBanTiposCuentas();
			
			if(!(mensaje.getNumero() == Utileria.convierteEntero(Constantes.STR_CODIGOEXITO[0]))) {
				throw new Exception(mensaje.getDescripcion());
			}	
			
			if(!parametros.getLisTiposCta().isEmpty()){
				String tipoCtaID = "";
				
				BanTiposCuentaBean banTiposCuentaBean = null;
				
				for(int i = 0; i<parametros.getLisTiposCta().size(); i++){
					tipoCtaID = (String) parametros.getLisTiposCta().get(i);
					banTiposCuentaBean = new BanTiposCuentaBean();
					banTiposCuentaBean.setTipoCuentaID(tipoCtaID);
					
					mensaje = banTiposCuentasDAO.altaBanTiposCuenta(banTiposCuentaBean);
					
					if(!(mensaje.getNumero() == Utileria.convierteEntero(Constantes.STR_CODIGOEXITO[0]))) {
						throw new Exception(mensaje.getDescripcion());
					}
				}
			}
			
			if (mensaje != null) 
				mensaje.setDescripcion("Parametros Modificados Exitosamente.");
			
		} catch (Exception e) {
			e.printStackTrace();
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(999);
			mensaje.setDescripcion(e.getMessage());
		}
		
		return mensaje;
	}
	
	public Object consulta(int numeroConsulta) {
		
		Object respuesta = null;
		
		try {
			loggerSAFI.info("BAMPARAMETROS");
			switch (numeroConsulta) {
				case Enum_Con_Parametros.principal:{
					respuesta = consultaPrincipal();
					return respuesta;
				}	
			}
			
		}catch(Exception e){
			
		}
		
		return respuesta;
	}

	private BAMParametrosBean consultaPrincipal() {
		loggerSAFI.info("Dentro de consulta principal");
		BAMParametrosBean parametros = null;
		parametros = parametrosDAO.consultaPrincipal();
		return parametros;
	}

	private BAMParametrosBean consultaProductosCreditos() {
		BAMParametrosBean parametros = null;
		parametros = parametrosDAO.consultaPrincipal();
		return parametros;
	}

	@Deprecated
	public MensajeTransaccionBean actualizaParametros(BAMParametrosBean paramtetros) {
		MensajeTransaccionBean mensaje = null;
		// mensaje = parametrosDAO.actualizaParametros(paramtetros,Enum_Act_Parametros.principal);
		return mensaje;
	}

	public BAMParametrosDAO getParametrosDAO() {
		return parametrosDAO;
	}

	public void setParametrosDAO(BAMParametrosDAO parametrosDAO) {
		this.parametrosDAO = parametrosDAO;
	}

	public BANProductoCreditoBeDAO getBanProductoCreditoBeDAO() {
		return banProductoCreditoBeDAO;
	}

	public void setBanProductoCreditoBeDAO(BANProductoCreditoBeDAO banProductoCreditoBeDAO) {
		this.banProductoCreditoBeDAO = banProductoCreditoBeDAO;
	}

	public BANTiposCuentasDAO getBanTiposCuentasDAO() {
		return banTiposCuentasDAO;
	}

	public void setBanTiposCuentasDAO(BANTiposCuentasDAO banTiposCuentasDAO) {
		this.banTiposCuentasDAO = banTiposCuentasDAO;
	}
	

}
