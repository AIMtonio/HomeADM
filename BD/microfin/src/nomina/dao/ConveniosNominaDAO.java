package nomina.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import nomina.bean.ConvenioNominaBean;
import nomina.bean.TipoEmpleadosConvenioBean;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

public class ConveniosNominaDAO extends BaseDAO {
	public MensajeTransaccionBean altaConveniosNomina(final ConvenioNominaBean convenioNominaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL CONVENIOSNOMINAALT (?,?,?,?,?,		?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,	?,?,?,	?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(convenioNominaBean.getInstitNominaID()));
									sentenciaStore.setString("Par_Descripcion",convenioNominaBean.getDescripcion());
									sentenciaStore.setString("Par_FechaRegistro",convenioNominaBean.getFechaRegistro());
									sentenciaStore.setString("Par_ManejaVencimiento",convenioNominaBean.getManejaVencimiento());
									sentenciaStore.setString("Par_FechaVencimiento", Utileria.convierteFecha(convenioNominaBean.getFechaVencimiento()));

									sentenciaStore.setString("Par_DomiciliacionPagos",convenioNominaBean.getDomiciliacionPagos());
									sentenciaStore.setString("Par_ClaveConvenio",convenioNominaBean.getClaveConvenio());
									sentenciaStore.setDouble("Par_Resguardo", Utileria.convierteDoble(convenioNominaBean.getResguardo()));
									sentenciaStore.setString("Par_RequiereFolio",convenioNominaBean.getRequiereFolio());
									sentenciaStore.setString("Par_ManejaQuinquenios",convenioNominaBean.getManejaQuinquenios());

									sentenciaStore.setInt("Par_UsuarioID",Utileria.convierteEntero(convenioNominaBean.getUsuarioID()));
									sentenciaStore.setString("Par_CorreoEjecutivo",convenioNominaBean.getCorreoEjecutivo());
									sentenciaStore.setString("Par_Comentario",convenioNominaBean.getComentario());
									sentenciaStore.setString("Par_ManejaCapPago",convenioNominaBean.getManejaCapPago());
									sentenciaStore.setString("Par_FormCapPago",convenioNominaBean.getFormCapPago());

									sentenciaStore.setString("Par_DesFormCapPago",convenioNominaBean.getDesFormCapPago());
									sentenciaStore.setString("Par_FormCapPagoRes",convenioNominaBean.getFormCapPagoRes());
									sentenciaStore.setString("Par_DesFormCapPagoRes",convenioNominaBean.getDesFormCapPagoRes());
									sentenciaStore.setString("Par_ManejaCalendario",convenioNominaBean.getManejaCalendario());
									sentenciaStore.setString("Par_ReportaIncidencia", convenioNominaBean.getReportaIncidencia());
									sentenciaStore.setString("Par_ManejaFechaIniCal",Utileria.convierteFecha(convenioNominaBean.getManejaFechaIniCal()));

									sentenciaStore.setInt("Par_NoCuotasCobrar", Utileria.convierteEntero(convenioNominaBean.getNoCuotasCobrar()));
									sentenciaStore.setString("Par_CobraComisionApert",convenioNominaBean.getCobraComisionApert());
									sentenciaStore.setString("Par_CobraMora",convenioNominaBean.getCobraMora());

									sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID", "ConveniosNominaDAO.altaConveniosNomina");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ConveniosNominaDAO.altaConveniosNomina");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoInt(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " ConveniosNominaDAO.altaConveniosNomina");
					} else if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error al registrar el convenio" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
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

	public MensajeTransaccionBean modificaConveniosNomina(final ConvenioNominaBean convenioNominaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL MODIFICACONVENIOSPRO (?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?	,?,?,?,?,?,		?,?,?,	?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ConvenioNominaID", Utileria.convierteEntero(convenioNominaBean.getConvenioNominaID()));
									sentenciaStore.setInt("Par_InstitNominaID", Utileria.convierteEntero(convenioNominaBean.getInstitNominaID()));
									sentenciaStore.setString("Par_Descripcion", convenioNominaBean.getDescripcion());
									sentenciaStore.setString("Par_ManejaVencimiento", convenioNominaBean.getManejaVencimiento());
									sentenciaStore.setString("Par_FechaVencimiento",  Utileria.convierteFecha(convenioNominaBean.getFechaVencimiento()));

									sentenciaStore.setString("Par_DomiciliacionPagos", convenioNominaBean.getDomiciliacionPagos());
									sentenciaStore.setString("Par_Estatus", convenioNominaBean.getEstatus());
									sentenciaStore.setString("Par_ClaveConvenio",convenioNominaBean.getClaveConvenio());
									sentenciaStore.setDouble("Par_Resguardo", Utileria.convierteDoble(convenioNominaBean.getResguardo()));
									sentenciaStore.setString("Par_RequiereFolio",convenioNominaBean.getRequiereFolio());

									sentenciaStore.setString("Par_ManejaQuinquenios",convenioNominaBean.getManejaQuinquenios());
									sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(convenioNominaBean.getUsuarioID()));
									sentenciaStore.setString("Par_CorreoEjecutivo",convenioNominaBean.getCorreoEjecutivo());
									sentenciaStore.setString("Par_Comentario", convenioNominaBean.getComentario());
									sentenciaStore.setString("Par_ManejaCapPago",convenioNominaBean.getManejaCapPago());

									sentenciaStore.setString("Par_FormCapPago",convenioNominaBean.getFormCapPago());
									sentenciaStore.setString("Par_DesFormCapPago",convenioNominaBean.getDesFormCapPago());
									sentenciaStore.setString("Par_FormCapPagoRes",convenioNominaBean.getFormCapPagoRes());
									sentenciaStore.setString("Par_DesFormCapPagoRes",convenioNominaBean.getDesFormCapPagoRes());
									sentenciaStore.setString("Par_ManejaCalendario",convenioNominaBean.getManejaCalendario());
									sentenciaStore.setString("Par_ReportaIncidencia",convenioNominaBean.getReportaIncidencia());

									sentenciaStore.setString("Par_ManejaFechaIniCal",Utileria.convierteFecha(convenioNominaBean.getManejaFechaIniCal()));
									sentenciaStore.setInt("Par_NoCuotasCobrar", Utileria.convierteEntero(convenioNominaBean.getNoCuotasCobrar()));
									sentenciaStore.setString("Par_CobraComisionApert",convenioNominaBean.getCobraComisionApert());
									sentenciaStore.setString("Par_CobraMora",convenioNominaBean.getCobraMora());
									sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());

									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "ConveniosNominaDAO.modificaConveniosNomina");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());

									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(resultadosStore.getInt("NumErr"));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ConveniosNominaDAO.modificaConveniosNomina");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoInt(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " ConveniosNominaDAO.modificaConveniosNomina");
					} else if(mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+" - "+" Error al modificar el registro del convenio" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
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

	public ConvenioNominaBean consultaConveniosNomina(int tipoConsulta, ConvenioNominaBean convenioNominaBean) {
		ConvenioNominaBean convenio = null;
		try {
			String query = "CALL CONVENIOSNOMINACON (?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {
					convenioNominaBean.getConvenioNominaID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ConveniosNominaDAO.consultaConveniosNomina",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL CONVENIOSNOMINACON (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConvenioNominaBean resultado = new ConvenioNominaBean();

					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					resultado.setDescripcion(resultSet.getString("Descripcion"));
					resultado.setFechaRegistro(resultSet.getString("FechaRegistro"));
					resultado.setManejaVencimiento(resultSet.getString("ManejaVencimiento"));
					resultado.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					resultado.setDomiciliacionPagos(resultSet.getString("DomiciliacionPagos"));
					resultado.setClaveConvenio(resultSet.getString("ClaveConvenio"));
					resultado.setEstatus(resultSet.getString("Estatus"));
					resultado.setResguardo(resultSet.getString("Resguardo"));
					resultado.setRequiereFolio(resultSet.getString("RequiereFolio"));
					resultado.setManejaQuinquenios(resultSet.getString("ManejaQuinquenios"));
					resultado.setNumActualizaciones(resultSet.getString("NumActualizaciones"));
					resultado.setUsuarioID(resultSet.getString("UsuarioID"));
					resultado.setCorreoEjecutivo(resultSet.getString("CorreoEjecutivo"));
					resultado.setComentario(resultSet.getString("Comentario"));
					resultado.setManejaCapPago(resultSet.getString("ManejaCapPago"));
					resultado.setFormCapPago(resultSet.getString("FormCapPago"));
					resultado.setFormCapPagoRes(resultSet.getString("FormCapPagoRes"));
					resultado.setManejaCalendario(resultSet.getString("ManejaCalendario"));
					resultado.setReportaIncidencia(resultSet.getString("ReportaIncidencia"));
					resultado.setManejaFechaIniCal(resultSet.getString("ManejaFechaIniCal"));
					resultado.setCobraComisionApert(resultSet.getString("CobraComisionApert"));
					resultado.setCobraMora(resultSet.getString("CobraMora"));
					resultado.setNombreCompleto(resultSet.getString("NombreCompleto"));
					resultado.setDesFormCapPago(resultSet.getString("DesFormCapPago"));
					resultado.setDesFormCapPagoRes(resultSet.getString("DesFormCapPagoRes"));
					resultado.setNoCuotasCobrar(resultSet.getString("NoCuotasCobrar"));

					return resultado;
				}
			});
			convenio = matches.size() > 0 ? (ConvenioNominaBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de convenios", e);
		}
		return convenio;
	}

	public List<?> listaConveniosNomina(int tipoLista, ConvenioNominaBean convenioNominaBean) {
		List<?> lista = null;
		try {
			String query = "CALL CONVENIOSNOMINALIS (?,?,?,?,?,	"
													+ "?,?,?,?,?,"
													+ "?);";
			Object[] parametros = {
					Utileria.convierteEntero(convenioNominaBean.getInstitNominaID()),
					convenioNominaBean.getDescripcion(),
					Constantes.ENTERO_CERO,
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ConveniosNominaDAO.listaConveniosNomina",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL CONVENIOSNOMINALIS (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConvenioNominaBean resultado = new ConvenioNominaBean();
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					resultado.setDescripcion(resultSet.getString("Descripcion"));
					resultado.setFechaRegistro(resultSet.getString("FechaRegistro"));
					resultado.setManejaVencimiento(resultSet.getString("ManejaVencimiento"));
					resultado.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					resultado.setDomiciliacionPagos(resultSet.getString("DomiciliacionPagos"));
					resultado.setEstatus(resultSet.getString("Estatus"));
					resultado.setUsuarioID(resultSet.getString("UsuarioID"));
					resultado.setNoCuotasCobrar(resultSet.getString("NoCuotasCobrar"));
					return resultado;
				}
			});
			lista = matches;
		} catch(Exception e) {
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de convenios", e);
		}
		return lista;
	}

	public List<?> listaConveniosActivos(int tipoLista, ConvenioNominaBean convenioNominaBean) {
		List<?> lista = null;
		try {
			String query = "CALL CONVENIOSNOMINALIS (?,?,?,?,?,"
													+ "	?,?,?,?,?,"
													+ "?);";
			Object[] parametros = {
					Utileria.convierteEntero(convenioNominaBean.getInstitNominaID()),
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ConveniosNominaDAO.listaConveniosNomina",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL CONVENIOSNOMINALIS (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConvenioNominaBean resultado = new ConvenioNominaBean();
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					resultado.setDescripcion(resultSet.getString("Descripcion"));
					resultado.setFechaRegistro(resultSet.getString("FechaRegistro"));
					resultado.setManejaVencimiento(resultSet.getString("ManejaVencimiento"));
					resultado.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					resultado.setDomiciliacionPagos(resultSet.getString("DomiciliacionPagos"));
					resultado.setEstatus(resultSet.getString("Estatus"));
					resultado.setUsuarioID(resultSet.getString("UsuarioID"));
					resultado.setNoCuotasCobrar(resultSet.getString("NoCuotasCobrar"));


					return resultado;
				}
			});
			lista = matches;
		} catch(Exception e) {
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de convenios", e);
		}
		return lista;
	}

	/* Lista de convenios de un cliente por institucion*/
	public List<?> listaConveniosCliente(int tipoLista, ConvenioNominaBean convenioNominaBean) {
		List<?> lista = null;
		try {
			String query = "CALL CONVENIOSNOMINALIS (?,?,?,?,?,	"
													+ "?,?,?,?,?,"
													+ "?);";
			Object[] parametros = {
					Utileria.convierteEntero(convenioNominaBean.getInstitNominaID()),
					Constantes.STRING_VACIO,
					Utileria.convierteEntero(convenioNominaBean.getClienteID()),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ConveniosNominaDAO.listaConveniosNomina",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL CONVENIOSNOMINALIS (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConvenioNominaBean resultado = new ConvenioNominaBean();
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					resultado.setDescripcion(resultSet.getString("Descripcion"));
					return resultado;
				}
			});
			lista = matches;
		} catch(Exception e) {
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de convenios", e);
		}
		return lista;
	}

	public List reporteAnaliticoCred(int tipoReporte, ConvenioNominaBean convenioNominaBean) {
		List lista = null;
		try {
			String query = "CALL ANALITICCREDNOMREP (?,?,?,	?,		?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(convenioNominaBean.getInstitNominaID()),
					Utileria.convierteEntero(convenioNominaBean.getConvenioNominaID()),
					Utileria.convierteFecha(convenioNominaBean.getFechaFin()),
					tipoReporte,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"TipoDocNominaDAO.reporteAnaliticoCred",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL ANALITICCREDNOMREP (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConvenioNominaBean resultado = new ConvenioNominaBean();
					resultado.setNombreInstitNomina(resultSet.getString("NombreInstit"));
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setEstatus(resultSet.getString("EstatusConv"));
					resultado.setClienteID(resultSet.getString("ClienteID"));
					/*resultado.setNoEmpleado(resultSet.getString("NoEmpleado"));
					resultado.setNombreCliente(resultSet.getString("NombreCliente"));
					resultado.setSucursalID(resultSet.getString("SucursalID"));*/
					resultado.setNombreSucurs(resultSet.getString("NombreSucurs"));
					/*resultado.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					resultado.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					resultado.setSaldo(resultSet.getString("Saldo"));
					resultado.setCreditoID(resultSet.getString("CreditoID"));
					resultado.setEstatusEmp(resultSet.getString("EstatusEmp"));
					resultado.setDescripcionProd(resultSet.getString("DescripcionProd"));
					resultado.setClasificacion(resultSet.getString("Clasificacion"));
					resultado.setTipoCredito(resultSet.getString("TipoCredito"));
					resultado.setMontoCredito(resultSet.getString("MontoCredito"));
					resultado.setFechaAutoriza(resultSet.getString("FechaAutoriza"));
					resultado.setFechaVencimien(resultSet.getString("FechaVencimien"));
					resultado.setMontoCuota(resultSet.getString("MontoCuota"));
					resultado.setFrecuenciaCap(resultSet.getString("FrecuenciaCap"));
					resultado.setSaldoCapVigent(resultSet.getString("SalCapVigente"));
					resultado.setSaldoCapVencido(resultSet.getString("SalCapVencido"));
					resultado.setIntDeveng(resultSet.getString("IntDeveng"));
					resultado.setSaldoTotal(resultSet.getString("SaldoTotal"));
					resultado.setSaldComFaltPago(resultSet.getString("SalComFaltaPago"));
					resultado.setAporteCliente(resultSet.getString("GarantiaLiquida"));
					resultado.setConAval(resultSet.getString("ConAval"));
					resultado.setTasaOrd(resultSet.getString("TasaOrd"));
					resultado.setTasaMora(resultSet.getString("TasaMora"));
					resultado.setNoCuotas(resultSet.getString("NumAmortizacion"));
					resultado.setCuoTranscu(resultSet.getString("CuoTranscu"));
					resultado.setCuoAtrasadas(resultSet.getString("CuoAtrasadas"));
					resultado.setCuoPendientes(resultSet.getString("CuoPendientes"));
					resultado.setEprcReq(resultSet.getString("EPRCReq"));
					resultado.setEprcCons(resultSet.getString("EPRCCons"));
					resultado.setEstatusCred(resultSet.getString("EstatusCred"));
					resultado.setFechaAsig(resultSet.getString("FechaAsig"));
					resultado.setInstanciaCobr(resultSet.getString("InstanciaCobr"));
					resultado.setNombreSuperv(resultSet.getString("NombreSuperv"));
					resultado.setNombreAbogado(resultSet.getString("NombreAbogado"));
					resultado.setNoCuotasPend(resultSet.getString("NoCuotasPend"));
					resultado.setDiasMora(resultSet.getString("DiasMora"));*/

					return resultado;
				}
			});
			lista = matches;
		} catch(Exception e) {
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de reporte analitico de creditos de nomina", e);
		}
		return lista;
	}

	public List<?> listaComboConvenios(int tipoLista, ConvenioNominaBean convenioNominaBean) {
		List<?> lista = null;
		try {
			String query = "CALL CONVENIOSNOMINALIS (?,?,?,?,?,	?,?,?,?,?,	?);";
			Object[] parametros = {
					Utileria.convierteEntero(convenioNominaBean.getInstitNominaID()),
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ConveniosNominaDAO.listaComboConvenios",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL CONVENIOSNOMINALIS (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConvenioNominaBean resultado = new ConvenioNominaBean();
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					resultado.setDescripcion(resultSet.getString("Descripcion"));
					resultado.setFechaRegistro(resultSet.getString("FechaRegistro"));
					resultado.setManejaVencimiento(resultSet.getString("ManejaVencimiento"));
					resultado.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					resultado.setDomiciliacionPagos(resultSet.getString("DomiciliacionPagos"));
					resultado.setEstatus(resultSet.getString("Estatus"));
					resultado.setUsuarioID(resultSet.getString("UsuarioID"));
					resultado.setNoCuotasCobrar(resultSet.getString("NoCuotasCobrar"));

					return resultado;
				}
			});
			lista = matches;
		} catch(Exception e) {
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de convenios", e);
		}
		return lista;
	}

	public List<?> listaConveniosComApert(int tipoLista, ConvenioNominaBean convenioNominaBean) {
		List<?> lista = null;
		try {
			String query = "CALL CONVENIOSNOMINALIS (?,?,?,?,?,"
													+ "	?,?,?,?,?,"
													+ "?);";
			Object[] parametros = {
					Utileria.convierteEntero(convenioNominaBean.getInstitNominaID()),
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ConveniosNominaDAO.listaConveniosNomina",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL CONVENIOSNOMINALIS (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConvenioNominaBean resultado = new ConvenioNominaBean();
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					resultado.setDescripcion(resultSet.getString("Descripcion"));
					resultado.setFechaRegistro(resultSet.getString("FechaRegistro"));
					resultado.setManejaVencimiento(resultSet.getString("ManejaVencimiento"));
					resultado.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					resultado.setDomiciliacionPagos(resultSet.getString("DomiciliacionPagos"));
					resultado.setEstatus(resultSet.getString("Estatus"));
					resultado.setUsuarioID(resultSet.getString("UsuarioID"));
					resultado.setNoCuotasCobrar(resultSet.getString("NoCuotasCobrar"));


					return resultado;
				}
			});
			lista = matches;
		} catch(Exception e) {
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de convenios", e);
		}
		return lista;
	}


	public ConvenioNominaBean convenioInstitucionNomina(int tipoConsulta, ConvenioNominaBean convenioNominaBean) {
		ConvenioNominaBean convenio = null;
		try {
			String query = "CALL CONVENIOSNOMINACON (?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {
				 	Utileria.convierteEntero(convenioNominaBean.getConvenioNominaID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ConveniosNominaDAO.convenioInstitucionNomina",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL CONVENIOSNOMINACON (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConvenioNominaBean resultado = new ConvenioNominaBean();
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					resultado.setDescripcion(resultSet.getString("Descripcion"));

					return resultado;
				}
			});
			convenio = matches.size() > 0 ? (ConvenioNominaBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de convenios", e);
		}
		return convenio;
	}

	/**
	 * Método que consulta la bandera que indica si un convenio reporta incidencias.
	 * @param tipoConsulta Tipo de consulta a realizar.
	 * @param convenioNominaBean Objeto que almacena el identificador del convenio a filtrar.
	 * @return Objeto que guarda la bandera consultada con su correspondiente convenio.
	 */
	public ConvenioNominaBean consultaReportaIncidencia(int tipoConsulta, ConvenioNominaBean convenioNominaBean) {
		ConvenioNominaBean convenio = null;
		try {
			String query = "CALL CONVENIOSNOMINACON (?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {
				 	Utileria.convierteEntero(convenioNominaBean.getConvenioNominaID()),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ConveniosNominaDAO.consultaReportaIncidencia",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL CONVENIOSNOMINACON (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConvenioNominaBean resultado = new ConvenioNominaBean();
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setReportaIncidencia(resultSet.getString("ReportaIncidencia"));

					return resultado;
				}
			});
			convenio = matches.size() > 0 ? (ConvenioNominaBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de convenios", e);
		}
		return convenio;
	}

	// Lista de los Convenios Activos por Institucion
		public List listaComboConveniosN(ConvenioNominaBean convenioNominaBean, int tipoConsulta){
			List listaConvenio = null;
			try{
			String query = "call CONVENIOSNOMINALIS(?,?,?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(convenioNominaBean.getInstitNominaID()),
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ConveniosNominaDAO.listaComboConvenios",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONVENIOSNOMINALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TipoEmpleadosConvenioBean tipompleadosConvBean = new TipoEmpleadosConvenioBean();

					tipompleadosConvBean.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					tipompleadosConvBean.setDescripcion(resultSet.getString("Descripcion"));
					return tipompleadosConvBean;
				}
			});
		   listaConvenio = matches ;
			}
		   catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Convenios de Nómina", e);
			}
			return listaConvenio;
		}

		// Lista de los Convenios Activos por Institucion con su atributo cobra mora
			public List<?> listaComboConvMora(int tipoLista, ConvenioNominaBean convenioNominaBean) {
				List<?> lista = null;
				try {
					String query = "CALL CONVENIOSNOMINALIS (?,?,?,?,?,	"
															+ "?,?,?,?,?,"
															+ "?);";
					Object[] parametros = {
							Utileria.convierteEntero(convenioNominaBean.getInstitNominaID()),
							convenioNominaBean.getDescripcion(),
							Constantes.ENTERO_CERO,
							tipoLista,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"ConveniosNominaDAO.listaConveniosNomina",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO};

					loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL CONVENIOSNOMINALIS (" + Arrays.toString(parametros) +")");
					List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							ConvenioNominaBean resultado = new ConvenioNominaBean();
							resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
							resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
							resultado.setDescripcion(resultSet.getString("Descripcion"));
							resultado.setCobraMora(resultSet.getString("CobraMora"));
							return resultado;
						}
					});
					lista = matches;
				} catch(Exception e) {
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de convenios", e);
				}
				return lista;
			}

		//LISTA PRINCIPAL
		public List<?> listaPrincipal(int tipoLista, ConvenioNominaBean convenioNominaBean) {
			List<?> lista = null;
			try {
				String query = "CALL CONVENIOSNOMINALIS (?,?,?,?,?,	"
														+ "?,?,?,?,?,"
														+ "?);";
				Object[] parametros = {
						Utileria.convierteEntero(convenioNominaBean.getInstitNominaID()),
						convenioNominaBean.getDescripcion(),
						Constantes.ENTERO_CERO,
						tipoLista,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"ConveniosNominaDAO.listaConveniosNomina",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO};

				loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL CONVENIOSNOMINALIS (" + Arrays.toString(parametros) +")");
				List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ConvenioNominaBean resultado = new ConvenioNominaBean();
						resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
						resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
						resultado.setDescripcion(resultSet.getString("Descripcion"));
						resultado.setFechaRegistro(resultSet.getString("FechaRegistro"));
						resultado.setManejaVencimiento(resultSet.getString("ManejaVencimiento"));
						resultado.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
						resultado.setDomiciliacionPagos(resultSet.getString("DomiciliacionPagos"));
						resultado.setEstatus(resultSet.getString("Estatus"));
						resultado.setUsuarioID(resultSet.getString("UsuarioID"));
						return resultado;
					}
				});
				lista = matches;
			} catch(Exception e) {
				loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de convenios", e);
			}
			return lista;
		}

}
