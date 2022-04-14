package psl.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.codec.binary.Base64;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import psl.bean.PSLHisProdBrokerBean;
import psl.bean.PSLParamBrokerBean;
import psl.bean.PSLProdBrokerBean;
import psl.beanrequest.ListaProductosBeanRequest;
import psl.beanresponse.ListaProductosBeanResponse;
import psl.beanresponse.ProductoBean;
import psl.rest.ConsumidorRest;

public class PSLProdBrokerDAO extends BaseDAO {
	ParametrosSesionBean parametrosSesionBean;
	PSLHisProdBrokerDAO pslHisProdBrokerDAO;
	PSLParamBrokerDAO pslParamBrokerDAO;

	public MensajeTransaccionBean actualizaCatalogoProductos(final PSLProdBrokerBean pslProdBrokerBean) {
		final Date fechaActual = new Date();
		SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String strFechaActual = null;
		try {
			strFechaActual = formato.format(fechaActual);
		}
		catch(Exception ignored) {}

		MensajeTransaccionBean mensaje = null;
		int actualizacionLlaveParametro = 1;
		String parametroActualizandoProductos = "ActualizandoProductos";
		String parametroFechaUltimaActualizacion = "FechaUltimaActualizacion";

		//Establecemos el parametro de actualizacion de parametros
		PSLParamBrokerBean pslParamBrokerBean = new PSLParamBrokerBean();
		pslParamBrokerBean.setLlaveParametro(parametroActualizandoProductos);
		pslParamBrokerBean.setValorParametro(Constantes.salidaSI);
		pslParamBrokerDAO.actualizaParametro(pslParamBrokerBean, actualizacionLlaveParametro);


		//Actualizamos los productos
		mensaje = actualizaProductosBroker(new PSLProdBrokerBean(), strFechaActual);
		if(mensaje.getNumero() == Constantes.ENTERO_CERO) {
			mensaje.setDescripcion("Catalogo de productos actualizado correctamente.");

			//Establecemos el parametro de actualizacion de parametros
			pslParamBrokerBean = new PSLParamBrokerBean();
			pslParamBrokerBean.setLlaveParametro(parametroFechaUltimaActualizacion);
			pslParamBrokerBean.setValorParametro(strFechaActual);
			pslParamBrokerDAO.actualizaParametro(pslParamBrokerBean, actualizacionLlaveParametro);
		}

		//Establecemos el parametro de actualizacion de parametros
		pslParamBrokerBean = new PSLParamBrokerBean();
		pslParamBrokerBean.setLlaveParametro(parametroActualizandoProductos);
		pslParamBrokerBean.setValorParametro(Constantes.STRING_NO);
		pslParamBrokerDAO.actualizaParametro(pslParamBrokerBean, actualizacionLlaveParametro);

		return mensaje;
	}

	/**
	 * Funcion que actualiza el Catalogo de Productos para el Pago de Servicios en Linea.
	 *
	 * @param pslProdBrokerBean
	 * @param strFechaActual
	 * @return
	 */
	private MensajeTransaccionBean actualizaProductosBroker(final PSLProdBrokerBean pslProdBrokerBean, final String strFechaActual) {
		MensajeTransaccionBean mensajeResultado = new MensajeTransaccionBean();
		//Abrimos transaccion
		transaccionDAO.generaNumeroTransaccion();
		mensajeResultado = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
				try {
					int listaPrincipal = 1;
					int procesoPaseHistorico = 1;

					//Consultamos la informacion del broker
					PSLParamBrokerBean pslParamBrokerBean = new PSLParamBrokerBean();
					PSLParamBrokerBean pslConfigBroker = pslParamBrokerDAO.consultaPrincipal(pslParamBrokerBean, listaPrincipal);

					//Consumimos la lista de productos del WS del Broker
					List<ProductoBean> productos = (List<ProductoBean>)consumeListaProductosBroker(pslConfigBroker);
					if(productos == null) {
						loggerSAFI.error("Ocurrio un error al consultar la lista de productos del Web Service del Broker.");
						mensajeTransaccionBean.setNumero(999);
						mensajeTransaccionBean.setDescripcion("Ocurrio un error al consultar la lista de productos del Web Service del Proveedor de Servicios.");
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

					//Pasamos los productos actuales del broker al historico
					PSLHisProdBrokerBean pslHisProdBrokerBean = new PSLHisProdBrokerBean();
					pslHisProdBrokerBean.setFechaPaseHis(strFechaActual);
					mensajeTransaccionBean = pslHisProdBrokerDAO.paseHistoricoProductosBroker(procesoPaseHistorico, pslHisProdBrokerBean);
					//Si ocurrio un error al pasar los catalogos al historico abortamos el proceso
					if(mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO) {
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

					PSLProdBrokerBean pslProdBrokerBean;
					//Insertamos los nuevos productos uno por uno
					for(ProductoBean productoBean: productos) {
						pslProdBrokerBean = new PSLProdBrokerBean();
						pslProdBrokerBean.setFechaCatalogo(strFechaActual);
						pslProdBrokerBean.setServicioID(productoBean.getIdServicio());
						pslProdBrokerBean.setServicio(productoBean.getServicio());
						pslProdBrokerBean.setTipoServicio(productoBean.getIdCatTipoServicio());
						pslProdBrokerBean.setProductoID(productoBean.getIdProducto());
						pslProdBrokerBean.setProducto(productoBean.getProducto());
						pslProdBrokerBean.setTipoFront(productoBean.getTipoFront());
						pslProdBrokerBean.setDigVerificador(productoBean.getHasDigitoVerificador());
						pslProdBrokerBean.setPrecio(productoBean.getPrecio());
						pslProdBrokerBean.setShowAyuda(productoBean.getShowAyuda());
						pslProdBrokerBean.setTipoReferencia(productoBean.getTipoReferencia());

						mensajeTransaccionBean = altaProductoBroker(pslProdBrokerBean);
						if(mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO) {
							throw new Exception(mensajeTransaccionBean.getDescripcion());
						}
					}

				}
				catch (Exception e) {
					if (mensajeTransaccionBean.getNumero() == 0) {
						mensajeTransaccionBean.setNumero(999);
					}
					mensajeTransaccionBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error al actualizar los productos del broker ", e);
				}

				return mensajeTransaccionBean;
			}
		});
		return mensajeResultado;
	}

	public List consumeListaProductosBroker(PSLParamBrokerBean pslParamBrokerBean) {
		loggerSAFI.info("Consultando lista de productos del Proveedor de Servicios");
		List listaProductos = null;
		String opcionListaProductos = "L01";
		String codigoExitoBroker = "000000";
		String url = pslParamBrokerBean.getUrlConexion() + "/brokerConsulta/listaProductos";
		String usuario = pslParamBrokerBean.getUsuario();
		String password = pslParamBrokerBean.getContrasenia();
		String autentificacion = usuario + ":" + password;
		byte[] encodedBytes = Base64.encodeBase64(autentificacion.getBytes());
		String autentificacionCodificada = new String(encodedBytes);

		ListaProductosBeanRequest beanRequest = new ListaProductosBeanRequest();
		beanRequest.setNumLista(opcionListaProductos);

		try {
			ConsumidorRest<ListaProductosBeanResponse> consumidorRest = new ConsumidorRest<ListaProductosBeanResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);

			ListaProductosBeanResponse listaProductosBeanResponse = consumidorRest.consumePost(url, beanRequest, ListaProductosBeanResponse.class);
			if(!codigoExitoBroker.equals(listaProductosBeanResponse.getCodigoRespuesta())) {
				loggerSAFI.info("Error al consultar los productos del WebService del Broker: " +
						listaProductosBeanResponse.getCodigoRespuesta() + " - " + listaProductosBeanResponse.getMensajeRespuesta());
				return null;
			}

			loggerSAFI.info("Respuesta del Proveedor de Servicios:" + listaProductosBeanResponse.getCodigoRespuesta() + " - " + listaProductosBeanResponse.getMensajeRespuesta());
			listaProductos = listaProductosBeanResponse.getProductos();
		}
		catch(Exception e) {
			loggerSAFI.info("Error al consultar los productos del Proveedor de Servicios:" + e.getMessage());
			e.printStackTrace();
		}

		return listaProductos;
	}

	/**
	 * Funcion para dar de alta un producto del broker de servicios.
	 *
	 * @param edoCtaTmpEnvioCorreoBean
	 * @param nombreOrigenDatos
	 * @return
	 */
	public MensajeTransaccionBean altaProductoBroker(final PSLProdBrokerBean pslProdBrokerBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL PSLPRODBROKERALT(?,?,?,?,?,?,?,?,?,?,?,   ?,?,?,  ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_FechaCatalogo", pslProdBrokerBean.getFechaCatalogo());
									sentenciaStore.setInt("Par_ServicioID", Utileria.convierteEntero(pslProdBrokerBean.getServicioID()));
									sentenciaStore.setString("Par_Servicio", pslProdBrokerBean.getServicio());
									sentenciaStore.setInt("Par_TipoServicio", Utileria.convierteEntero(pslProdBrokerBean.getTipoServicio()));
									sentenciaStore.setInt("Par_ProductoID", Utileria.convierteEntero(pslProdBrokerBean.getProductoID()));
									sentenciaStore.setString("Par_Producto", pslProdBrokerBean.getProducto());
									sentenciaStore.setInt("Par_TipoFront", Utileria.convierteEntero(pslProdBrokerBean.getTipoFront()));
									sentenciaStore.setString("Par_DigVerificador", pslProdBrokerBean.getDigVerificador());
									sentenciaStore.setDouble("Par_Precio", Utileria.convierteDoble(pslProdBrokerBean.getPrecio()));
									sentenciaStore.setString("Par_ShowAyuda", pslProdBrokerBean.getShowAyuda());
									sentenciaStore.setString("Par_TipoReferencia", pslProdBrokerBean.getTipoReferencia());

									//Parametros de salida
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Par_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Par_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Par_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Par_ProgramaID", "EdoCtaEnvioCorreoDAO.altaEdoCtaEnvioCorreo");
									sentenciaStore.setInt("Par_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Par_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .PSLProdBrokerDAO.altaPSLProdBroker");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .PSLProdBrokerDAO.altaPSLProdBroker");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al realizar el alta de productos del broker " + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public PSLHisProdBrokerDAO getPslHisProdBrokerDAO() {
		return pslHisProdBrokerDAO;
	}

	public void setPslHisProdBrokerDAO(PSLHisProdBrokerDAO pslHisProdBrokerDAO) {
		this.pslHisProdBrokerDAO = pslHisProdBrokerDAO;
	}

	public PSLParamBrokerDAO getPslParamBrokerDAO() {
		return pslParamBrokerDAO;
	}

	public void setPslParamBrokerDAO(PSLParamBrokerDAO pslParamBrokerDAO) {
		this.pslParamBrokerDAO = pslParamBrokerDAO;
	}
}
