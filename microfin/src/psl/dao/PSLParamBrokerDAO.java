package psl.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import psl.bean.PSLParamBrokerBean;
import psl.beanrequest.ListaProductosBeanRequest;
import psl.beanresponse.ListaProductosBeanResponse;
import psl.rest.ConsumidorRest;

public class PSLParamBrokerDAO extends BaseDAO {
	ParametrosSesionBean parametrosSesionBean;

	private final static String salidaPantalla = "S";
	private static final String parametroActualizacionDiariaProductos = "ActualizacionDiariaProductos";
	private static final String parametroHoraActualizacionProductos = "HoraActualizacioProductos";
	private static final String parametroUsuarioHubServicios = "UsuarioHubServicios";
	private static final String parametroPasswordHubServicios = "PasswordHubServicios";
	private static final String parametroURLHubServicios = "URLHubServicios";
	private static final String parametroFechaUltimaAct = "FechaUltimaActualizacion";
	private static final String parametroActualizandoProductos = "ActualizandoProductos";

	public PSLParamBrokerBean consultaPrincipal(PSLParamBrokerBean paramBrokerBean,int tipoConsulta) {
		PSLParamBrokerBean paramBrokerBeanResult = null;

		try {
			List<PSLParamBrokerBean> paramBrokerList = this.listaPrincipal(paramBrokerBean, tipoConsulta);
			if(paramBrokerList == null || paramBrokerList.size() == 0) {
				throw new Exception("Error al consultar la lista de los parametros.");
			}

			paramBrokerBeanResult = new PSLParamBrokerBean();
			for(PSLParamBrokerBean bean: paramBrokerList) {
				if(bean.getLlaveParametro().equals(parametroActualizacionDiariaProductos)) {
					paramBrokerBeanResult.setActualizacionDiaria(bean.getValorParametro());
				}
				else if(bean.getLlaveParametro().equals(parametroHoraActualizacionProductos)) {
					paramBrokerBeanResult.setHoraActualizacion(bean.getValorParametro());
				}
				else if(bean.getLlaveParametro().equals(parametroUsuarioHubServicios)) {
					paramBrokerBeanResult.setUsuario(bean.getValorParametro());
				}
				else if(bean.getLlaveParametro().equals(parametroPasswordHubServicios)) {
					paramBrokerBeanResult.setContrasenia(bean.getValorParametro());
				}
				else if(bean.getLlaveParametro().equals(parametroURLHubServicios)) {
					paramBrokerBeanResult.setUrlConexion(bean.getValorParametro());
				}
				else if(bean.getLlaveParametro().equals(parametroFechaUltimaAct)) {
					paramBrokerBeanResult.setFechaUltimaActualizacion(bean.getValorParametro());
				}
				else if(bean.getLlaveParametro().equals(parametroActualizandoProductos)) {
					paramBrokerBeanResult.setActualizandoProductos(bean.getValorParametro());
				}
			}
		}
		catch(Exception e) {
			paramBrokerBeanResult = null;

			loggerSAFI.info("Error al consultar los parametros del broker: " + e.getMessage());
			e.printStackTrace();
		}

		return paramBrokerBeanResult;
	}

	public MensajeTransaccionBean actualizacionPrincipal(PSLParamBrokerBean paramBrokerBean, int tipoTransaccion) {
		MensajeTransaccionBean mensaje = null;

		PSLParamBrokerBean paramBrokerBeanRequest = null;

		paramBrokerBeanRequest = new PSLParamBrokerBean();
		paramBrokerBeanRequest.setLlaveParametro(parametroActualizacionDiariaProductos);
		paramBrokerBeanRequest.setValorParametro(paramBrokerBean.getActualizacionDiaria());
		mensaje = this.actualizaParametro(paramBrokerBeanRequest, tipoTransaccion);
		if(mensaje.getNumero() != 0) {
			return mensaje;
		}

		paramBrokerBeanRequest = new PSLParamBrokerBean();
		paramBrokerBeanRequest.setLlaveParametro(parametroHoraActualizacionProductos);
		paramBrokerBeanRequest.setValorParametro(paramBrokerBean.getHoraActualizacion());
		mensaje = this.actualizaParametro(paramBrokerBeanRequest, tipoTransaccion);
		if(mensaje.getNumero() != 0) {
			return mensaje;
		}

		paramBrokerBeanRequest = new PSLParamBrokerBean();
		paramBrokerBeanRequest.setLlaveParametro(parametroUsuarioHubServicios);
		paramBrokerBeanRequest.setValorParametro(paramBrokerBean.getUsuario());
		mensaje = this.actualizaParametro(paramBrokerBeanRequest, tipoTransaccion);
		if(mensaje.getNumero() != 0) {
			return mensaje;
		}

		paramBrokerBeanRequest = new PSLParamBrokerBean();
		paramBrokerBeanRequest.setLlaveParametro(parametroPasswordHubServicios);
		paramBrokerBeanRequest.setValorParametro(paramBrokerBean.getContrasenia());
		mensaje = this.actualizaParametro(paramBrokerBeanRequest, tipoTransaccion);
		if(mensaje.getNumero() != 0) {
			return mensaje;
		}

		paramBrokerBeanRequest = new PSLParamBrokerBean();
		paramBrokerBeanRequest.setLlaveParametro(parametroURLHubServicios);
		paramBrokerBeanRequest.setValorParametro(paramBrokerBean.getUrlConexion());
		mensaje = this.actualizaParametro(paramBrokerBeanRequest, tipoTransaccion);
		if(mensaje.getNumero() != 0) {
			return mensaje;
		}

		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(Constantes.ENTERO_CERO);
		mensaje.setDescripcion("Actualizacion de parametros correcta");

		return mensaje;
	}





	public PSLParamBrokerBean consultaParametro(PSLParamBrokerBean paramBrokerBean, int tipoConsulta){
		String query = "call PSLPARAMBROKERCON (?,?,  ?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,

			tipoConsulta,

			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.FECHA_VACIA,
			Constantes.STRING_VACIO,
			"ParamBrokerDAO.consultaParametro",
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO
		};

		//Logueamos la sentencia
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PSLPARAMBROKERCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PSLParamBrokerBean paramBrokerBean = new PSLParamBrokerBean();
				paramBrokerBean.setLlaveParametro(resultSet.getString("LlaveParametro"));
				paramBrokerBean.setValorParametro(resultSet.getString("ValorParametro"));

				return paramBrokerBean;
			}
		});


		return matches.size() > 0 ? (PSLParamBrokerBean) matches.get(0) : null;
	}

	public MensajeTransaccionBean actualizaParametro(final PSLParamBrokerBean paramBrokerBean, final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PSLPARAMBROKERACT(?,?,  ?,	 ?,?,?,  ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_LlaveParametro", paramBrokerBean.getLlaveParametro());
								sentenciaStore.setString("Par_ValorParametro", paramBrokerBean.getValorParametro());
								//Numero de actualizacion
								sentenciaStore.setInt("Par_NumAct",tipoTransaccion);
								//Parametros de salida
								sentenciaStore.setString("Par_Salida",salidaPantalla);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								//Parametros de Auditoria
								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}
								else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .PSLParamBrokerDAO.actualizaParametro");
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
						throw new Exception(Constantes.MSG_ERROR + " .ParamBrokerDAO.actualizaParametro");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al actualizar el parametro del broker " + e);
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

	public List listaPrincipal(final PSLParamBrokerBean paramBrokerBean, int tipoLista) {
		String query = "call PSLPARAMBROKERLIS(?,?, ?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
			Constantes.STRING_VACIO,
			Constantes.STRING_VACIO,

			tipoLista,

			parametrosAuditoriaBean.getEmpresaID(),
			parametrosAuditoriaBean.getUsuario(),
			parametrosAuditoriaBean.getFecha(),
			parametrosAuditoriaBean.getDireccionIP(),
			"ParamBrokerDAO.listaPrincipal",
			parametrosAuditoriaBean.getSucursal(),
			parametrosAuditoriaBean.getNumeroTransaccion()
		};


		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PSLPARAMBROKERLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PSLParamBrokerBean paramBrokerBean = new PSLParamBrokerBean();
				paramBrokerBean.setLlaveParametro(resultSet.getString("LlaveParametro"));
				paramBrokerBean.setValorParametro(resultSet.getString("ValorParametro"));

				return paramBrokerBean;

			}
		});

		return matches;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
