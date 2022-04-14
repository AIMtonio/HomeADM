package originacion.dao;

import org.pentaho.di.ui.core.dialog.ShowMessageDialog;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.SistemaLogging;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Types;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.core.CollectionFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.JdbcUtils;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;







import cobranza.bean.EmisionNotiCobBean;
import originacion.bean.MonitorSolicitudesBean;



public class MonitorSolicitudesDAO extends BaseDAO{

	java.sql.Date fecha = null;
	public ParametrosSesionBean parametrosSesionBean = null;
	public MonitorSolicitudesDAO() {
		super();
	}
	private final static String salidaPantalla = "S";


	public MensajeTransaccionBean modificaEstatusSolicitud(final MonitorSolicitudesBean solicitudes,final MonitorSolicitudesBean monitorSolicitudesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
		mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call MONITORSOLICITUDESPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								if(Utileria.convierteEntero(solicitudes.getSolicitudCreditoID())== 0){
									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(solicitudes.getCreditoID()));
								}
								else{
									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(solicitudes.getSolicitudCreditoID()));
								}
								sentenciaStore.setString("Par_Condicionada",solicitudes.getValorSolventar());
								sentenciaStore.setString("Par_Comentario",solicitudes.getComentario());
								Utileria.convierteEntero(monitorSolicitudesBean.getClaveUsuario());
								sentenciaStore.setInt("Par_Usuario", Utileria.convierteEntero(monitorSolicitudesBean.getClaveUsuario()));
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Monitor de Solicitud de Credito", e);

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean actualizaEstatus(final MonitorSolicitudesBean solicitudes,final MonitorSolicitudesBean monitorSolicitudesBean,final long NumeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call SOLICITUDESASIGNACIONESACT("+
										"?,?,?,?,?  ," +
										"?,?,?,?,?	," +
										"?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								try{

								sentenciaStore.setLong("Par_SolicitudCreditoID",Utileria.convierteLong(solicitudes.getSolicitudCreditoID()));
								sentenciaStore.setString("Par_Estatus",solicitudes.getEstatusSolicitud());
								sentenciaStore.setInt("Par_NumAct",Constantes.ENTERO_CERO+1);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","MonitorSolicitudesDAO");

								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",NumeroTransaccion);
								loggerSAFI.info(sentenciaStore.toString());
								return sentenciaStore;
								} catch(Exception ex){
									ex.printStackTrace();
									loggerSAFI.info(sentenciaStore.toString());
									return null;
								}

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

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error("error en alta de asignacion de analista", e);
				}
				return mensajeBean;
			}
		});

		return mensaje;
	}



	//Consulta Monto Total Creditos pendientes por Otorgar
		public MonitorSolicitudesBean consultaPrincipal(MonitorSolicitudesBean monitorSolicitudesBean, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call MONITORSOLICITUDESCON(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = { tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSOTORGARCON(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					MonitorSolicitudesBean creditosOtorgarBean = new MonitorSolicitudesBean();

					return creditosOtorgarBean;
				}
			});
			return matches.size() > 0 ? (MonitorSolicitudesBean) matches.get(0) : null;
		}


		public List<Map<String, Object>> detalleCreditos(final int tipoConsulta, final String productoCredito, final String sucursal, final String empresaNomina){

			List<Map<String, Object>> list = null;

			try{
				String query = "call CREDITOSOTORGARCON(?,?,?,?,?, ?,?,?,?,?, ?);";
				Object[] parametros = {
							tipoConsulta,
							productoCredito,
							sucursal,
							empresaNomina,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,

							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"CreditosOtorgarDAO.detalleCreditos",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
							};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSOTORGARCON(" + Arrays.toString(parametros) +")");
					List<Map<String, Object>> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Map<String, Object> mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						ResultSetMetaData rsmd = (ResultSetMetaData) resultSet.getMetaData();

						int columnCount = rsmd.getColumnCount();
						Map mapOfColValues = createColumnMap(columnCount);

						for (int i = 1; i <= columnCount; i++) {
							  String key = getColumnKey(rsmd.getColumnName(i));
						      Object obj = getColumnValue(resultSet, i);

						      mapOfColValues.put(key, obj);
						  }
						return mapOfColValues;
					}
				});

				list = matches;

			}catch (Exception e) {
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en detalle consola", e);
			}
			return list;
		}

		public MensajeTransaccionBean grabaEstatus(final MonitorSolicitudesBean monitorSolicitudesBean,final List listaSolicitudesSolventar,final int tipoModifica) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						MonitorSolicitudesBean solicitudes;
							for(int i=0; i<listaSolicitudesSolventar.size(); i++){
								solicitudes = (MonitorSolicitudesBean)listaSolicitudesSolventar.get(i);
								mensajeBean = modificaEstatusSolicitud(solicitudes,monitorSolicitudesBean);
									if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}

							}

					} catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							transaccionDAO.generaNumeroTransaccion();
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Monitor de Solicitud de Credito", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		public MensajeTransaccionBean grabaEstatusAct(final MonitorSolicitudesBean monitorSolicitudesBean,final List listaSolicitudesAct,final int tipoModifica) {
			transaccionDAO.generaNumeroTransaccion();
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						MonitorSolicitudesBean solicitudes;
							for(int i=0; i<listaSolicitudesAct.size(); i++){
								solicitudes = (MonitorSolicitudesBean)listaSolicitudesAct.get(i);
								mensajeBean = actualizaEstatus(solicitudes,monitorSolicitudesBean,parametrosAuditoriaBean.getNumeroTransaccion());
									if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}

							}

					} catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							transaccionDAO.generaNumeroTransaccion();
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Monitor de Solicitud de Credito", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


		public List listaCantidadSolicitudesDAO(int tipoLista,MonitorSolicitudesBean monitorSolicitudesBean){
			transaccionDAO.generaNumeroTransaccion();
			monitorSolicitudesBean.setNumTransaccion(parametrosAuditoriaBean.getNumeroTransaccion()+"");
			String query = "call MONITORSOLICITUDESLIS(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?);";

			Object[] parametros = {
					tipoLista,
					monitorSolicitudesBean.getFechaInicio(),
					Utileria.convierteEntero(monitorSolicitudesBean.getSucursalID()),
					Utileria.convierteEntero(monitorSolicitudesBean.getPromotorID()),
					monitorSolicitudesBean.getEstatus(),
					Utileria.convierteEntero(monitorSolicitudesBean.getProductoCreditoID()),
					Utileria.convierteEntero(monitorSolicitudesBean.getUsuarioID()),
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"MonitorSolicitudesDAO",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MONITORSOLICITUDESLIS(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					MonitorSolicitudesBean monitorSolicitudesBean = new MonitorSolicitudesBean();
					monitorSolicitudesBean.setEstatusValor(resultSet.getString("EstatusValor"));
					monitorSolicitudesBean.setTipoEstatus(resultSet.getString("TipoEstatus"));
					monitorSolicitudesBean.setTotalEstUsuario(resultSet.getString("TotalEstatusU"));

					return monitorSolicitudesBean;
				}
			});
			return matches;
		}

		public List listaDetalleSolicitudesDAO(int tipoLista,MonitorSolicitudesBean monitorSolicitudesBean){
			String query = "call MONITORSOLICITUDESLIS(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?);";

			Object[] parametros = {
					tipoLista,
					monitorSolicitudesBean.getFechaInicio(),
					Utileria.convierteEntero(monitorSolicitudesBean.getSucursalID()),
					Utileria.convierteEntero(monitorSolicitudesBean.getPromotorID()),
					monitorSolicitudesBean.getEstatus(),
					Utileria.convierteEntero(monitorSolicitudesBean.getProductoCreditoID()),
					Utileria.convierteEntero(monitorSolicitudesBean.getUsuarioID()),
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"MonitorSolicitudesDAO",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MONITORSOLICITUDESLIS(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					MonitorSolicitudesBean monitorSolicitudesBean = new MonitorSolicitudesBean();
					Date Fecha = resultSet.getDate("Fecha");
					Time Hora = resultSet.getTime("Fecha");
					String FechaComentario;
					if(Fecha == null){
						FechaComentario = "";
					}else{
						FechaComentario = Fecha + " " + Hora;
					}
					monitorSolicitudesBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					monitorSolicitudesBean.setCreditoID(resultSet.getString("CreditoID"));
					monitorSolicitudesBean.setClienteID(resultSet.getString("ClienteID"));
					monitorSolicitudesBean.setNombreCliente(resultSet.getString("NombreCompleto"));
					monitorSolicitudesBean.setPromotorID(resultSet.getString("PromotorID"));
					monitorSolicitudesBean.setNombrePromotor(resultSet.getString("NombrePromotor"));
					monitorSolicitudesBean.setUsuarioID(resultSet.getString("UsuarioID"));
					monitorSolicitudesBean.setNombreUsuario(resultSet.getString("NombreUsuario"));
					monitorSolicitudesBean.setComentarioSol(resultSet.getString("Comentario"));
					monitorSolicitudesBean.setFechaComentario(FechaComentario);
					monitorSolicitudesBean.setNombreSucursal(resultSet.getString("NombreSucursal"));
					monitorSolicitudesBean.setDescripcionProducto(resultSet.getString("DescripcionProducto"));
					monitorSolicitudesBean.setMontoOtorgado(resultSet.getString("MontoOtorgado"));
					monitorSolicitudesBean.setClaveAnalista(resultSet.getString("ClaveAnalista"));
					monitorSolicitudesBean.setDescripcionRegreso(resultSet.getString("DescripcionRegreso"));
					monitorSolicitudesBean.setEstatusSolicitud(resultSet.getString("EstatusSolicitud"));
					monitorSolicitudesBean.setTipoAsignacionID(resultSet.getString("TipoAsignacionID"));


					return monitorSolicitudesBean;
				}
			});
			return matches;
		}

		public List listaCanalIngresoSolicitudesDAO(int tipoLista,MonitorSolicitudesBean monitorSolicitudesBean){

			String query = "call MONITORSOLICITUDESLIS(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?);";

			Object[] parametros = {
					tipoLista,
					monitorSolicitudesBean.getFechaInicio(),
					Utileria.convierteEntero(monitorSolicitudesBean.getSucursalID()),
					Utileria.convierteEntero(monitorSolicitudesBean.getPromotorID()),
					monitorSolicitudesBean.getEstatus(),
					Utileria.convierteEntero(monitorSolicitudesBean.getProductoCreditoID()),
					Utileria.convierteEntero(monitorSolicitudesBean.getUsuarioID()),
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"MonitorSolicitudesDAO",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MONITORSOLICITUDESLIS(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					MonitorSolicitudesBean monitorSolicitudesBean = new MonitorSolicitudesBean();

					monitorSolicitudesBean.setTotalCanalIng(resultSet.getString("CanalIngreso"));
					monitorSolicitudesBean.setTipoCanalIng(resultSet.getString("TipoCanal"));

					return monitorSolicitudesBean;
				}
			});
			return matches;
		}




		protected Map createColumnMap(int columnCount) {
			return CollectionFactory.createLinkedCaseInsensitiveMapIfPossible(columnCount);
		}

		protected String getColumnKey(String columnName) {
			return columnName;
		}

		protected Object getColumnValue(ResultSet rs, int index) throws SQLException {
	         return JdbcUtils.getResultSetValue(rs, index);
		}

}

