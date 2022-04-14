package cliente.dao;

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

import cliente.bean.InfoAdiContaBean;

public class InfoAdiContaDAO extends BaseDAO {

	ParametrosSesionBean	parametrosSesionBean	= null;

	public MensajeTransaccionBean alta(final InfoAdiContaBean infoAdiContaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call INFORMACIONADICACREDALT(" +
									"?,?,?,?,?,		" +
									"?,?,?,?,?,		" +

									"?,?,?,?,?,		" +
									"?,?,?,?,?,		" +

									"?,?,?,?,?,		" +
									"?,?,?,?,?,		" +

									"?,?,?,?,?,		" +
									"?,?,?,?,?,		" +

									"?,?,?,?,?,		" +
									"?,?,?,?,?,		" +

									"?,?,?,?,?,		" +
									"?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							try{
							sentenciaStore.setInt("Par_Acreditado", Utileria.convierteEntero(infoAdiContaBean.getAcreditado()));
							sentenciaStore.setDouble("Par_ActivoCirculante", Utileria.convierteDoble(infoAdiContaBean.getActivoCirculante()));
							sentenciaStore.setDouble("Par_ActivoProductivos", Utileria.convierteDoble(infoAdiContaBean.getActivoProductivos()));
							sentenciaStore.setDouble("Par_ActivoSujetosRiesgo", Utileria.convierteDoble(infoAdiContaBean.getActivoSujetosRiesgo()));
							sentenciaStore.setInt("Par_AnioIngresosBruto", Utileria.convierteEntero(infoAdiContaBean.getAnioIngresosBruto()));
							sentenciaStore.setInt("Par_CalificacionExterna", Utileria.convierteEntero(infoAdiContaBean.getCalificacionExterna()));
							sentenciaStore.setDouble("Par_CarteraCredito", Utileria.convierteDoble(infoAdiContaBean.getCarteraCredito()));
							sentenciaStore.setDouble("Par_CarteraNeta", Utileria.convierteDoble(infoAdiContaBean.getCarteraNeta()));
							sentenciaStore.setDouble("Par_CarteraVencida", Utileria.convierteDoble(infoAdiContaBean.getCarteraVencida()));
							sentenciaStore.setInt("Par_Clientes", Utileria.convierteEntero(infoAdiContaBean.getClientes()));
							sentenciaStore.setInt("Par_Competencia", Utileria.convierteEntero(infoAdiContaBean.getCompetencia()));
							sentenciaStore.setInt("Par_CompAccionaria", Utileria.convierteEntero(infoAdiContaBean.getComposicionAccionaria()));
							sentenciaStore.setInt("Par_ConsejoAdmin", Utileria.convierteEntero(infoAdiContaBean.getConsejoAdmin()));
							sentenciaStore.setInt("Par_CumpleContaGuberna", Utileria.convierteEntero(infoAdiContaBean.getCumpleContaGuberna()));
							sentenciaStore.setDouble("Par_DepositoDeBienes", Utileria.convierteDoble(infoAdiContaBean.getDepositoDeBienes()));
							sentenciaStore.setInt("Par_EmisionTitulos", Utileria.convierteEntero(infoAdiContaBean.getEmisionTitulos()));
							sentenciaStore.setInt("Par_EntidadRegulada", Utileria.convierteEntero(infoAdiContaBean.getEntidadRegulada()));
							sentenciaStore.setInt("Par_EstructOrgan", Utileria.convierteEntero(infoAdiContaBean.getEstructOrgan()));
							sentenciaStore.setInt("Par_FechaEdoFinan",Utileria.convierteEntero(infoAdiContaBean.getFechaEdoFinan()));
							sentenciaStore.setInt("Par_FechEdoFinanVentNet", Utileria.convierteEntero(infoAdiContaBean.getFechaEdoFinanVentasNetas()));
							sentenciaStore.setDouble("Par_FondeoTotal", Utileria.convierteDoble(infoAdiContaBean.getFondeoTotal()));
							sentenciaStore.setDouble("Par_GastosAdmin", Utileria.convierteDoble(infoAdiContaBean.getGastosAdmin()));
							sentenciaStore.setDouble("Par_GastosFinan", Utileria.convierteDoble(infoAdiContaBean.getGastosFinan()));
							sentenciaStore.setDouble("Par_IngresosBrutos", Utileria.convierteDoble(infoAdiContaBean.getIngresosBrutos()));
							sentenciaStore.setDouble("Par_IngresosTotales", Utileria.convierteDoble(infoAdiContaBean.getIngresosTotales()));
							sentenciaStore.setDouble("Par_MargenFinan", Utileria.convierteDoble(infoAdiContaBean.getMargenFinan()));
							sentenciaStore.setInt("Par_NivelPoliticas", Utileria.convierteEntero(infoAdiContaBean.getNivelPoliticas()));
							sentenciaStore.setInt("Par_NumeroEmpleados", Utileria.convierteEntero(infoAdiContaBean.getNumeroEmpleados()));
							sentenciaStore.setInt("Par_NumeroLineasNeg", Utileria.convierteEntero(infoAdiContaBean.getNumeroLineasNeg()));
							sentenciaStore.setDouble("Par_PasivoCirculante", Utileria.convierteDoble(infoAdiContaBean.getPasivoCirculante()));
							sentenciaStore.setDouble("Par_PasivoExigible", Utileria.convierteDoble(infoAdiContaBean.getPasivoExigible()));
							sentenciaStore.setDouble("Par_PasivoLargoPlazo", Utileria.convierteDoble(infoAdiContaBean.getPasivoLargoPlazo()));
							sentenciaStore.setInt("Par_PeriodoAudEdos", Utileria.convierteEntero(infoAdiContaBean.getPeriodosAudEdoFin()));
							sentenciaStore.setInt("Par_ProcesoAuditoria", Utileria.convierteEntero(infoAdiContaBean.getProcesoAuditoria()));
							sentenciaStore.setInt("Par_Proveedores", Utileria.convierteEntero(infoAdiContaBean.getProveedores()));
							sentenciaStore.setDouble("Par_ROE", Utileria.convierteDoble(infoAdiContaBean.getROE()));
							sentenciaStore.setDouble("Par_TasaRetLaboral1", Utileria.convierteDoble(infoAdiContaBean.getTasaRetLaboral1()));
							sentenciaStore.setDouble("Par_TasaRetLaboral2", Utileria.convierteDoble(infoAdiContaBean.getTasaRetLaboral2()));
							sentenciaStore.setDouble("Par_TasaRetLaboral3", Utileria.convierteDoble(infoAdiContaBean.getTasaRetLaboral3()));
							sentenciaStore.setInt("Par_TipoEntidad", Utileria.convierteEntero(infoAdiContaBean.getTipoEntidad()));
							sentenciaStore.setDouble("Par_UtilAntGastImpues", Utileria.convierteDoble(infoAdiContaBean.getUtilidaAntesGastosImpues()));
							sentenciaStore.setDouble("Par_UtilidaNeta", Utileria.convierteDoble(infoAdiContaBean.getUtilidaNeta()));
							sentenciaStore.setDouble("Par_EPRC", Utileria.convierteDoble(infoAdiContaBean.getEprc()));
							sentenciaStore.setInt("Par_NumFuentes", Utileria.convierteEntero(infoAdiContaBean.getNumFuentes()));
							sentenciaStore.setDouble("Par_SaldosAcreditados", Utileria.convierteDoble(infoAdiContaBean.getSaldoAcreditados()));

							sentenciaStore.setInt("Par_NumConsejerosInd", Utileria.convierteEntero(infoAdiContaBean.getNumConsejerosInd()));
							sentenciaStore.setInt("Par_NumConsejerosTot", Utileria.convierteEntero(infoAdiContaBean.getNumConsejerosTot()));
							sentenciaStore.setDouble("Par_PorcParticipacionAcc", Utileria.convierteDoble(infoAdiContaBean.getPorcParticipacionAcc()));

							sentenciaStore.setDouble("Par_CapitalContable", Utileria.convierteDoble(infoAdiContaBean.getCapitalContable()));
							sentenciaStore.setInt("Par_ExpLaboral", Utileria.convierteEntero(infoAdiContaBean.getExpLaboral()));
							sentenciaStore.setString("Par_Salida", "S");
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "ConsDirectivosDAO.consultaPermisos");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());

							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
							}catch(Exception ex){
								ex.printStackTrace();
							}
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .InfoAdiContaDAO.alta");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .InfoAdiContaDAO.alta");
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Alta de Informacion Adicional: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modificacion(final InfoAdiContaBean infoAdiContaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call INFORMACIONADICACREDMOD(" +
									"?,?,?,?,?,		" +
									"?,?,?,?,?,		" +
									"?,?,?,?,?,		" +
									"?,?,?,?,?,		" +
									"?,?,?,?,?,		" +
									"?,?,?,?,?,		" +
									"?,?,?,?,?,		" +
									"?,?,?,?,?,		" +
									"?,?,?,?,?,		" +
									"?,?,?,?,?,		" +
									"?,?,?,?,?,		" +
									"?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							try{
							sentenciaStore.setInt("Par_Acreditado", Utileria.convierteEntero(infoAdiContaBean.getAcreditado()));
							sentenciaStore.setDouble("Par_ActivoCirculante", Utileria.convierteDoble(infoAdiContaBean.getActivoCirculante()));
							sentenciaStore.setDouble("Par_ActivoProductivos", Utileria.convierteDoble(infoAdiContaBean.getActivoProductivos()));
							sentenciaStore.setDouble("Par_ActivoSujetosRiesgo", Utileria.convierteDoble(infoAdiContaBean.getActivoSujetosRiesgo()));
							sentenciaStore.setInt("Par_AnioIngresosBruto", Utileria.convierteEntero(infoAdiContaBean.getAnioIngresosBruto()));
							sentenciaStore.setInt("Par_CalificacionExterna", Utileria.convierteEntero(infoAdiContaBean.getCalificacionExterna()));
							sentenciaStore.setDouble("Par_CarteraCredito", Utileria.convierteDoble(infoAdiContaBean.getCarteraCredito()));
							sentenciaStore.setDouble("Par_CarteraNeta", Utileria.convierteDoble(infoAdiContaBean.getCarteraNeta()));
							sentenciaStore.setDouble("Par_CarteraVencida", Utileria.convierteDoble(infoAdiContaBean.getCarteraVencida()));
							sentenciaStore.setInt("Par_Clientes", Utileria.convierteEntero(infoAdiContaBean.getClientes()));
							sentenciaStore.setInt("Par_Competencia", Utileria.convierteEntero(infoAdiContaBean.getCompetencia()));
							sentenciaStore.setInt("Par_CompAccionaria", Utileria.convierteEntero(infoAdiContaBean.getComposicionAccionaria()));
							sentenciaStore.setInt("Par_ConsejoAdmin", Utileria.convierteEntero(infoAdiContaBean.getConsejoAdmin()));
							sentenciaStore.setInt("Par_CumpleContaGuberna", Utileria.convierteEntero(infoAdiContaBean.getCumpleContaGuberna()));
							sentenciaStore.setDouble("Par_DepositoDeBienes", Utileria.convierteDoble(infoAdiContaBean.getDepositoDeBienes()));
							sentenciaStore.setInt("Par_EmisionTitulos", Utileria.convierteEntero(infoAdiContaBean.getEmisionTitulos()));
							sentenciaStore.setInt("Par_EntidadRegulada", Utileria.convierteEntero(infoAdiContaBean.getEntidadRegulada()));
							sentenciaStore.setInt("Par_EstructOrgan", Utileria.convierteEntero(infoAdiContaBean.getEstructOrgan()));
							sentenciaStore.setInt("Par_FechaEdoFinan",Utileria.convierteEntero(infoAdiContaBean.getFechaEdoFinan()));
							sentenciaStore.setInt("Par_FechEdoFinanVentNet", Utileria.convierteEntero(infoAdiContaBean.getFechaEdoFinanVentasNetas()));
							sentenciaStore.setDouble("Par_FondeoTotal", Utileria.convierteDoble(infoAdiContaBean.getFondeoTotal()));
							sentenciaStore.setDouble("Par_GastosAdmin", Utileria.convierteDoble(infoAdiContaBean.getGastosAdmin()));
							sentenciaStore.setDouble("Par_GastosFinan", Utileria.convierteDoble(infoAdiContaBean.getGastosFinan()));
							sentenciaStore.setDouble("Par_IngresosBrutos", Utileria.convierteDoble(infoAdiContaBean.getIngresosBrutos()));
							sentenciaStore.setDouble("Par_IngresosTotales", Utileria.convierteDoble(infoAdiContaBean.getIngresosTotales()));
							sentenciaStore.setDouble("Par_MargenFinan", Utileria.convierteDoble(infoAdiContaBean.getMargenFinan()));
							sentenciaStore.setInt("Par_NivelPoliticas", Utileria.convierteEntero(infoAdiContaBean.getNivelPoliticas()));
							sentenciaStore.setInt("Par_NumeroEmpleados", Utileria.convierteEntero(infoAdiContaBean.getNumeroEmpleados()));
							sentenciaStore.setInt("Par_NumeroLineasNeg", Utileria.convierteEntero(infoAdiContaBean.getNumeroLineasNeg()));
							sentenciaStore.setDouble("Par_PasivoCirculante", Utileria.convierteDoble(infoAdiContaBean.getPasivoCirculante()));
							sentenciaStore.setDouble("Par_PasivoExigible", Utileria.convierteDoble(infoAdiContaBean.getPasivoExigible()));
							sentenciaStore.setDouble("Par_PasivoLargoPlazo", Utileria.convierteDoble(infoAdiContaBean.getPasivoLargoPlazo()));
							sentenciaStore.setInt("Par_PeriodoAudEdos", Utileria.convierteEntero(infoAdiContaBean.getPeriodosAudEdoFin()));
							sentenciaStore.setInt("Par_ProcesoAuditoria", Utileria.convierteEntero(infoAdiContaBean.getProcesoAuditoria()));
							sentenciaStore.setInt("Par_Proveedores", Utileria.convierteEntero(infoAdiContaBean.getProveedores()));
							sentenciaStore.setDouble("Par_ROE", Utileria.convierteDoble(infoAdiContaBean.getROE()));
							sentenciaStore.setDouble("Par_TasaRetLaboral1", Utileria.convierteDoble(infoAdiContaBean.getTasaRetLaboral1()));
							sentenciaStore.setDouble("Par_TasaRetLaboral2", Utileria.convierteDoble(infoAdiContaBean.getTasaRetLaboral2()));
							sentenciaStore.setDouble("Par_TasaRetLaboral3", Utileria.convierteDoble(infoAdiContaBean.getTasaRetLaboral3()));
							sentenciaStore.setInt("Par_TipoEntidad", Utileria.convierteEntero(infoAdiContaBean.getTipoEntidad()));
							sentenciaStore.setDouble("Par_UtilAntGastImpues", Utileria.convierteDoble(infoAdiContaBean.getUtilidaAntesGastosImpues()));
							sentenciaStore.setDouble("Par_UtilidaNeta", Utileria.convierteDoble(infoAdiContaBean.getUtilidaNeta()));
							sentenciaStore.setDouble("Par_EPRC", Utileria.convierteDoble(infoAdiContaBean.getEprc()));
							sentenciaStore.setInt("Par_NumFuentes", Utileria.convierteEntero(infoAdiContaBean.getNumFuentes()));
							sentenciaStore.setDouble("Par_SaldosAcreditados", Utileria.convierteDoble(infoAdiContaBean.getSaldoAcreditados()));
							sentenciaStore.setInt("Par_NumConsejerosInd", Utileria.convierteEntero(infoAdiContaBean.getNumConsejerosInd()));
							sentenciaStore.setInt("Par_NumConsejerosTot", Utileria.convierteEntero(infoAdiContaBean.getNumConsejerosTot()));
							sentenciaStore.setDouble("Par_PorcParticipacionAcc", Utileria.convierteDoble(infoAdiContaBean.getPorcParticipacionAcc()));
							sentenciaStore.setDouble("Par_CapitalContable", Utileria.convierteDoble(infoAdiContaBean.getCapitalContable()));
							sentenciaStore.setInt("Par_ExpLaboral", Utileria.convierteEntero(infoAdiContaBean.getExpLaboral()));

							sentenciaStore.setString("Par_Salida", "S");

							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "ConsDirectivosDAO.consultaPermisos");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());

							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
							}catch(Exception ex){
								ex.printStackTrace();
							}
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .InfoAdiContaDAO.modificacion");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .InfoAdiContaDAO.alta");
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Alta de Informacion Adicional: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public InfoAdiContaBean consulta(InfoAdiContaBean infoAdiContaBean, int tipoConsulta) {
		try {
			String query = "call INFORMACIONADICACREDCON(" + "?,?,?,?,?,			" + "?,?,?,?);";
			Object[] parametros = {infoAdiContaBean.getAcreditado(), tipoConsulta, Constantes.ENTERO_CERO, Constantes.ENTERO_CERO, Constantes.FECHA_VACIA, Constantes.STRING_VACIO, "InfoAdiContaDAO.consulta", Constantes.ENTERO_CERO, Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call INFORMACIONADICACREDCON(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					InfoAdiContaBean bean = new InfoAdiContaBean();

					bean.setAcreditado(resultSet.getString("Acreditado"));
					bean.setActivoCirculante(resultSet.getString("ActivoCirculante"));
					bean.setActivoProductivos(resultSet.getString("ActivoProductivos"));
					bean.setActivoSujetosRiesgo(resultSet.getString("ActivoSujetosRiesgo"));
					bean.setAnioIngresosBruto(resultSet.getString("AnioIngresosBruto"));
					bean.setCalificacionExterna(resultSet.getString("CalificacionExterna"));
					bean.setCarteraCredito(resultSet.getString("CarteraCredito"));
					bean.setCarteraNeta(resultSet.getString("CarteraNeta"));
					bean.setCarteraVencida(resultSet.getString("CarteraVencida"));
					bean.setClientes(resultSet.getString("Clientes"));
					bean.setCompetencia(resultSet.getString("Competencia"));
					bean.setComposicionAccionaria(resultSet.getString("CompAccionaria"));
					bean.setConsejoAdmin(resultSet.getString("ConsejoAdmin"));
					bean.setCumpleContaGuberna(resultSet.getString("CumpleContaGuberna"));
					bean.setDepositoDeBienes(resultSet.getString("DepositoDeBienes"));
					bean.setEmisionTitulos(resultSet.getString("EmisionTitulos"));
					bean.setEntidadRegulada(resultSet.getString("EntidadRegulada"));
					bean.setEstructOrgan(resultSet.getString("EstructOrgan"));
					bean.setFechaEdoFinan(resultSet.getString("FechaEdoFinan"));
					bean.setFechaEdoFinanVentasNetas(resultSet.getString("FechEdoFinanVentNet"));
					bean.setFondeoTotal(resultSet.getString("FondeoTotal"));
					bean.setGastosAdmin(resultSet.getString("GastosAdmin"));
					bean.setGastosFinan(resultSet.getString("GastosFinan"));
					bean.setIngresosBrutos(resultSet.getString("IngresosBrutos"));
					bean.setIngresosTotales(resultSet.getString("IngresosTotales"));
					bean.setMargenFinan(resultSet.getString("MargenFinan"));
					bean.setNivelPoliticas(resultSet.getString("NivelPoliticas"));
					bean.setNumeroEmpleados(resultSet.getString("NumeroEmpleados"));
					bean.setNumeroLineasNeg(resultSet.getString("NumeroLineasNeg"));
					bean.setPasivoCirculante(resultSet.getString("PasivoCirculante"));
					bean.setPasivoExigible(resultSet.getString("PasivoExigible"));
					bean.setPasivoLargoPlazo(resultSet.getString("PasivoLargoPlazo"));
					bean.setPeriodosAudEdoFin(resultSet.getString("PeriodosAudEdoFin"));
					bean.setProcesoAuditoria(resultSet.getString("ProcesoAuditoria"));
					bean.setProveedores(resultSet.getString("Proveedores"));
					bean.setROE(resultSet.getString("ROE"));
					bean.setTasaRetLaboral1(resultSet.getString("TasaRetLaboral1"));
					bean.setTasaRetLaboral2(resultSet.getString("TasaRetLaboral2"));
					bean.setTasaRetLaboral3(resultSet.getString("TasaRetLaboral3"));
					bean.setTipoSociedad(resultSet.getString("TipoSociedad"));
					bean.setTipoEntidad(resultSet.getString("TipoEntidad"));
					bean.setUtilidaAntesGastosImpues(resultSet.getString("UtilAntGastImpues"));
					bean.setUtilidaNeta(resultSet.getString("UtilidaNeta"));
					bean.setTipoSub(resultSet.getString("MostrarPantalla"));
					bean.setNombreAcreditado(resultSet.getString("NombreCompleto"));
					bean.setTipoTransaccion(resultSet.getString("TipoTransaccion"));
					bean.setMostrarSi(resultSet.getString("MostrarSi"));
					bean.setEprc(resultSet.getString("EPRC"));
					bean.setNumFuentes(resultSet.getString("NumFuentes"));
					bean.setSaldoAcreditados(resultSet.getString("SaldoAcreditados"));
					bean.setNumConsejerosInd(resultSet.getString("NumConsejerosInd"));
					bean.setNumConsejerosTot(resultSet.getString("NumConsejerosTot"));
					bean.setPorcParticipacionAcc(resultSet.getString("PorcParticipacionAcc"));
					bean.setCapitalContable(resultSet.getString("CapitalContable"));
					bean.setExpLaboral(resultSet.getString("ExpLaboral"));

					return bean;
				}
			});
			return matches.size() > 0 ? (InfoAdiContaBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return null;

	}
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
