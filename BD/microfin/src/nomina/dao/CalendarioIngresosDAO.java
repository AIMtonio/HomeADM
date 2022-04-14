package nomina.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import nomina.bean.CalendarioIngresosBean;
import nomina.bean.TipoEmpleadosConvenioBean;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import contabilidad.bean.FrecTimbradoProducBean;
import credito.bean.AvalesPorSoliciDetalleBean;
import credito.bean.ProductosCreditoBean;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class CalendarioIngresosDAO  extends BaseDAO {


	// Consulta principal
	public CalendarioIngresosBean consultaPrincipal(CalendarioIngresosBean calendarioIngresosBean, int tipoConsulta){
		CalendarioIngresosBean calendarioIng = new CalendarioIngresosBean();
		try{
		String query = "call CALENDARIOINGRESOSCON(?,?,?,?,?, ?,?,?,?,?, ?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(calendarioIngresosBean.getInstitNominaID()),
				Utileria.convierteEntero(calendarioIngresosBean.getConvenioNominaID()),
				Utileria.convierteEntero(calendarioIngresosBean.getAnio()),
				calendarioIngresosBean.getEstatus(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CalendarioIngresosDAO.consultaEstatus",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CALENDARIOINGRESOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CalendarioIngresosBean calendarioIngresosBean = new CalendarioIngresosBean();

				calendarioIngresosBean.setInstitNominaID(resultSet.getString("InstitNominaID"));
				calendarioIngresosBean.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
				calendarioIngresosBean.setAnio(resultSet.getString("Anio"));
				calendarioIngresosBean.setEstatus(resultSet.getString("Estatus"));
				calendarioIngresosBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
				calendarioIngresosBean.setFechaLimiteEnvio(resultSet.getString("FechaLimiteEnvio"));
				calendarioIngresosBean.setFechaPrimerDesc(resultSet.getString("FechaPrimerDesc"));
				calendarioIngresosBean.setFechaLimiteRecep(resultSet.getString("FechaLimiteRecep"));
				calendarioIngresosBean.setNumCuotas(resultSet.getString("NumCuotas"));

				return calendarioIngresosBean;
			}
		});
		calendarioIng =  matches.size() > 0 ? (CalendarioIngresosBean) matches.get(0) : null;
		}
	   catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Estatus de Calendario de Ingresos", e);
		}
		return calendarioIng;
	}

	// Lista de los Años dependiendo del Calendario de Ingresos
			public List lisAniosCalendar( int tipoConsulta){

				List listaConvenio = null;
				try{
				String query = "call CALENDARIOINGRESOSLIS(?,?,?,?,?, ?,?,?,?,?, ?,?);";
				Object[] parametros = {
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.STRING_VACIO,
						tipoConsulta,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"CalendarioIngresosDAO.lisAniosCalendar",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CALENDARIOINGRESOSLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						CalendarioIngresosBean calendarioIngresosBean = new CalendarioIngresosBean();

						calendarioIngresosBean.setAnio(resultSet.getString("Anio"));
						return calendarioIngresosBean;
					}
				});
			   listaConvenio = matches ;
				}
			   catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Años de Calendario de Ingresos", e);
				}
				return listaConvenio;
			}

			// Consulta de los Estatus del Calendario de Ingresos
				public CalendarioIngresosBean consultaEstatus(CalendarioIngresosBean calendarioIngresosBean, int tipoConsulta){
					CalendarioIngresosBean calendarioIng = new CalendarioIngresosBean();
					try{
					String query = "call CALENDARIOINGRESOSCON(?,?,?,?,?, ?,?,?,?,?, ?,?);";
					Object[] parametros = {
							Utileria.convierteEntero(calendarioIngresosBean.getInstitNominaID()),
							Utileria.convierteEntero(calendarioIngresosBean.getConvenioNominaID()),
							Utileria.convierteEntero(calendarioIngresosBean.getAnio()),
							Constantes.STRING_VACIO,
							tipoConsulta,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"CalendarioIngresosDAO.consultaEstatus",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CALENDARIOINGRESOSCON(" + Arrays.toString(parametros) +")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							CalendarioIngresosBean calendarioIngresosBean = new CalendarioIngresosBean();
							calendarioIngresosBean.setEstatus(resultSet.getString("Estatus"));
							return calendarioIngresosBean;
						}
					});
					calendarioIng =  matches.size() > 0 ? (CalendarioIngresosBean) matches.get(0) : null;
					}
				   catch(Exception e){
						e.printStackTrace();
						loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Estatus de Calendario de Ingresos", e);
					}
					return calendarioIng;
				}


				// Lista de Calendario de Ingresos
				public List listaCalendarioIng(CalendarioIngresosBean calendarioIngresosBean, int tipoConsulta){
					List listaConvenio = null;
					try{
					String query = "call CALENDARIOINGRESOSLIS(?,?,?,?,?, ?,?,?,?,?, ?,?);";
					Object[] parametros = {
							Utileria.convierteEntero(calendarioIngresosBean.getInstitNominaID()),
							Utileria.convierteEntero(calendarioIngresosBean.getConvenioNominaID()),
							Utileria.convierteEntero(calendarioIngresosBean.getAnio()),
							calendarioIngresosBean.getEstatus(),
							tipoConsulta,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"CalendarioIngresosDAO.listaCalendarioIng",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CALENDARIOINGRESOSLIS(" + Arrays.toString(parametros) +")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							CalendarioIngresosBean calendarioIngresosBean = new CalendarioIngresosBean();

							calendarioIngresosBean.setFechaLimiteEnvio(resultSet.getString("FechaLimiteEnvio"));
							calendarioIngresosBean.setFechaPrimerDesc(resultSet.getString("FechaPrimerDesc"));
							calendarioIngresosBean.setFechaLimiteRecep(resultSet.getString("FechaLimiteRecep"));
							calendarioIngresosBean.setNumCuotas(resultSet.getString("NumCuotas"));

							return calendarioIngresosBean;
						}
					});
				   listaConvenio = matches ;
					}
				   catch(Exception e){
						e.printStackTrace();
						loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de la Informacion de Calendario de Ingresos", e);
					}
					return listaConvenio;
				}

				public MensajeTransaccionBean grabarCalendarioIng(final CalendarioIngresosBean calendarioIngresosBean,final List listaCalendarioIng) {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					transaccionDAO.generaNumeroTransaccion();

					mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							try {
								CalendarioIngresosBean calendarioIngresos = null;
								mensajeBean = bajaCalendarioIng(calendarioIngresosBean);
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}

								for(int i=0; i<listaCalendarioIng.size(); i++){
									calendarioIngresos = (CalendarioIngresosBean)listaCalendarioIng.get(i);
									calendarioIngresos.setInstitNominaID(calendarioIngresosBean.getInstitNominaID());
									calendarioIngresos.setConvenioNominaID(calendarioIngresosBean.getConvenioNominaID());
									calendarioIngresos.setAnio(calendarioIngresosBean.getAnio());
									calendarioIngresos.setEstatus(calendarioIngresosBean.getEstatus());
									calendarioIngresos.setUsuarioID(calendarioIngresosBean.getUsuarioID());
									mensajeBean = altaCalendarioIng(calendarioIngresos);
								}


								mensajeBean.setNumero(0);
								mensajeBean.setDescripcion("Calendario de Ingresos agregado Exitosamente.");
								mensajeBean.setNombreControl("calendarioID");
								mensajeBean.setConsecutivoInt(mensajeBean.getConsecutivoInt());
							} catch (Exception e) {
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error de Calendario de Ingresos", e);
								if(mensajeBean.getNumero()==0){
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

				public MensajeTransaccionBean autorizarCalendIng(final CalendarioIngresosBean calendarioIngresosBea, final int tipoAct) {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							try {

								// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

											String query = "call CALENDARIOINGRESOSACT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?);";
											CallableStatement sentenciaStore = arg0.prepareCall(query);

											sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(calendarioIngresosBea.getInstitNominaID()));
											sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(calendarioIngresosBea.getConvenioNominaID()));
											sentenciaStore.setInt("Par_Anio",Utileria.convierteEntero(calendarioIngresosBea.getAnio()));
											sentenciaStore.setInt("Par_UsuarioID",Utileria.convierteEntero(calendarioIngresosBea.getUsuarioID()));

											sentenciaStore.setInt("Par_NumAct",tipoAct);

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
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la actualización del Calendario de Ingresos", e);
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


				public MensajeTransaccionBean desautorizarCalendIng(final CalendarioIngresosBean calendarioIngresosBea,final int tipoAct) {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							try {

								// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

											String query = "call CALENDARIOINGRESOSACT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?);";
											CallableStatement sentenciaStore = arg0.prepareCall(query);

											sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(calendarioIngresosBea.getInstitNominaID()));
											sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(calendarioIngresosBea.getConvenioNominaID()));
											sentenciaStore.setInt("Par_Anio",Utileria.convierteEntero(calendarioIngresosBea.getAnio()));
											sentenciaStore.setInt("Par_UsuarioID",Utileria.convierteEntero(calendarioIngresosBea.getUsuarioID()));
											sentenciaStore.setInt("Par_NumAct",tipoAct);

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
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la actualización del Calendario de Ingresos", e);
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


				public MensajeTransaccionBean altaCalendarioIng(final CalendarioIngresosBean calendarioIngresosBea) {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							try {

								// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

											String query = "call CALENDARIOINGRESOSALT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?);";
											CallableStatement sentenciaStore = arg0.prepareCall(query);

											sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(calendarioIngresosBea.getInstitNominaID()));
											sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(calendarioIngresosBea.getConvenioNominaID()));
											sentenciaStore.setInt("Par_Anio",Utileria.convierteEntero(calendarioIngresosBea.getAnio()));
											sentenciaStore.setString("Par_Estatus",calendarioIngresosBea.getEstatus());
											sentenciaStore.setString("Par_FechaLimEnvio",calendarioIngresosBea.getFechaLimiteEnvio());
											sentenciaStore.setString("Par_FechaPrimerDesc",calendarioIngresosBea.getFechaPrimerDesc());
											sentenciaStore.setString("Par_FechaLimiteRecep",calendarioIngresosBea.getFechaLimiteRecep());
											sentenciaStore.setInt("Par_NumCuotas",Utileria.convierteEntero(calendarioIngresosBea.getNumCuotas()));
											sentenciaStore.setInt("Par_UsuarioID",Utileria.convierteEntero(calendarioIngresosBea.getUsuarioID()));

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
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la alta del Calendario de Ingresos", e);
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


				public MensajeTransaccionBean bajaCalendarioIng(final CalendarioIngresosBean calendarioIngresosBean) {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							try {

								// Query con el Store Procedure
								mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

											String query = "call CALENDARIOINGRESOSBAJ(?,?, ?,?,?,  ?,?,?,?,?, ?,?,?,?);";
											CallableStatement sentenciaStore = arg0.prepareCall(query);

											sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(calendarioIngresosBean.getInstitNominaID()));
											sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(calendarioIngresosBean.getConvenioNominaID()));
											sentenciaStore.setInt("Par_Anio",Utileria.convierteEntero(calendarioIngresosBean.getAnio()));
											sentenciaStore.setString("Par_Estatus",calendarioIngresosBean.getEstatus());

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
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la baja del Calendario de Ingresos", e);
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

				//CONSULTA FECHA LIMITE DE ENVIO
				public CalendarioIngresosBean consultaFechaLimEnvio(CalendarioIngresosBean calendarioIngresosBean, int tipoConsulta){
					CalendarioIngresosBean calendarioIng = new CalendarioIngresosBean();
					try{
					String query = "call CALENDARIOINGRESOSCON(?,?,?,?,?, ?,?,?,?,?, ?,?);";
					Object[] parametros = {
							Utileria.convierteEntero(calendarioIngresosBean.getInstitNominaID()),
							Utileria.convierteEntero(calendarioIngresosBean.getConvenioNominaID()),
							Utileria.convierteEntero(calendarioIngresosBean.getAnio()),
							calendarioIngresosBean.getEstatus(),
							tipoConsulta,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"CalendarioIngresosDAO.consultaEstatus",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CALENDARIOINGRESOSCON(" + Arrays.toString(parametros) +")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							CalendarioIngresosBean calendarioIngresosBean = new CalendarioIngresosBean();

							calendarioIngresosBean.setInstitNominaID(resultSet.getString("InstitNominaID"));
							calendarioIngresosBean.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
							calendarioIngresosBean.setAnio(resultSet.getString("Anio"));
							calendarioIngresosBean.setEstatus(resultSet.getString("Estatus"));
							calendarioIngresosBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
							calendarioIngresosBean.setFechaLimiteEnvio(resultSet.getString("FechaLimiteEnvio"));
							calendarioIngresosBean.setFechaPrimerDesc(resultSet.getString("FechaPrimerDesc"));
							calendarioIngresosBean.setFechaLimiteRecep(resultSet.getString("FechaLimiteRecep"));
							calendarioIngresosBean.setNumCuotas(resultSet.getString("NumCuotas"));
							calendarioIngresosBean.setFechaPrimerAmorti(resultSet.getString("FechaPrimerAmorti"));

							return calendarioIngresosBean;
						}
					});
					calendarioIng =  matches.size() > 0 ? (CalendarioIngresosBean) matches.get(0) : null;
					}
				   catch(Exception e){
						e.printStackTrace();
						loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Estatus de Calendario de Ingresos", e);
					}
					return calendarioIng;
				}

}
