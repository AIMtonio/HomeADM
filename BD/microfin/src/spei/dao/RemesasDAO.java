package spei.dao;

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

import spei.bean.RemesasBean;
import herramientas.Constantes;
import herramientas.Utileria;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;

import general.bean.ParametrosSesionBean;

public class RemesasDAO extends BaseDAO {

	public static String STRING_TOPOT = "T";

	public List consultaSolRemesas(String origenDatos, int tipoConsulta) {
		List remesasBeanCon = null;
		try{
			// Query con el Store Procedure
			String query = "CALL SPEISOLDESREMCON(?,?, ?,?,?,?,?,?,?);";

			Object[] parametros = { Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"RemesasDAO.consultaSolRemesas",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO };
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+" CALL SPEISOLDESREMCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					RemesasBean resultado = new RemesasBean();
					resultado.setSpeiSolDesID(resultSet.getString("SpeiSolDesID"));
					return resultado;
				}
			});
			remesasBeanCon= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de solicitud con cede o inversion en garantia ", e);
		}
		return remesasBeanCon;
	}

	public RemesasBean consultaRemeAct(RemesasBean remesaBean, int tipoConsulta) {
		RemesasBean consultaBean = null;
		try{
			// Query con el Store Procedure
			String query = "CALL SPEIREMESASCON(?,?,?,?,?, ?,?,?, ?,?,?,?,?,?);";

			Object[] parametros = { Constantes.ENTERO_CERO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"RemesasDAO.consultaRemeAct",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO };
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+" CALL SPEIREMESASCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					RemesasBean resultado = new RemesasBean();
					resultado.setSpeiRemID(resultSet.getString("SpeiRemID"));
					resultado.setClaveRastreo(resultSet.getString("ClaveRastreo"));
					return resultado;
				}
			});
			consultaBean= matches.size() > 0 ? (RemesasBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de solicitud con cede o inversion en garantia ", e);
		}
		return consultaBean;
	}

	// Alta de Remeas
	public MensajeTransaccionBean altaRemesa(final RemesasBean remesasBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL SPEIDESCARGASREMALT("+
														"?,?,?,?,?, ?,?,?,?,?," +
														"?,?,?,?,?, ?,?,?,?,?," +
														"?,?,?,?,?, ?,?,?,?,?," +
														"?,?,?,?,?, ?,?,?,?,?," +
														"?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_SpeiSolDesID", Utileria.convierteEntero(remesasBean.getSpeiSolDesID()));
									sentenciaStore.setString("Par_ClaveRastreo", remesasBean.getClaveRastreo());
									sentenciaStore.setInt("Par_TipoPago", Utileria.convierteEntero(remesasBean.getTipoPagoID()));
									sentenciaStore.setInt("Par_TipoCuentaOrd", Utileria.convierteEntero(remesasBean.getTipoCuentaOrd()));
									sentenciaStore.setString("Par_CuentaOrd", remesasBean.getCuentaOrd());
									sentenciaStore.setString("Par_NombreOrd", remesasBean.getNombreOrd());

									sentenciaStore.setString("Par_RFCOrd", remesasBean.getRFCOrd());
									sentenciaStore.setInt("Par_TipoOperacion", Utileria.convierteEntero(remesasBean.getTipoOperacion()));
									sentenciaStore.setDouble("Par_MontoTransferir", Utileria.convierteDoble(remesasBean.getMontoTransferir()));
									sentenciaStore.setDouble("Par_IVA", Utileria.convierteDoble(remesasBean.getiVAPorPagar()));
									sentenciaStore.setDouble("Par_ComisionTrans", Constantes.ENTERO_CERO);
									sentenciaStore.setDouble("Par_IVAComision", Constantes.ENTERO_CERO);

									sentenciaStore.setInt("Par_InstiRemitente", Utileria.convierteEntero(remesasBean.getInstiRemitenteID()));
									sentenciaStore.setInt("Par_InstiReceptora", Utileria.convierteEntero(remesasBean.getInstiReceptoraID()));
									sentenciaStore.setString("Par_CuentaBeneficiario", remesasBean.getCuentaBeneficiario());
									sentenciaStore.setString("Par_NombreBeneficiario", remesasBean.getNombreBeneficiario());
									sentenciaStore.setString("Par_RFCBeneficiario", remesasBean.getRFCBeneficiario());

									sentenciaStore.setInt("Par_TipoCuentaBen", Utileria.convierteEntero(remesasBean.getTipoCuentaBen()));
									sentenciaStore.setString("Par_ConceptoPago", remesasBean.getConceptoPago());
									sentenciaStore.setString("Par_CuentaBenefiDos", remesasBean.getCuentaBenefiDos());
									sentenciaStore.setString("Par_NombreBenefiDos", remesasBean.getNombreBenefiDos());
									sentenciaStore.setString("Par_RFCBenefiDos", remesasBean.getRFCBenefiDos());

									sentenciaStore.setInt("Par_TipoCuentaBenDos", Utileria.convierteEntero(remesasBean.getTipoCuentaBenDos()));
									sentenciaStore.setString("Par_ConceptoPagoDos", remesasBean.getConceptoPagoDos());
									sentenciaStore.setString("Par_ReferenciaCobranza", remesasBean.getReferenciaCobranza());

									sentenciaStore.setInt("Par_ReferenciaNum", Utileria.convierteEntero(remesasBean.getReferenciaNum()));
									sentenciaStore.setInt("Par_Prioridad", Utileria.convierteEntero(remesasBean.getPrioridadEnvio()));

									sentenciaStore.setInt("Par_EstatusRem", Utileria.convierteEntero(remesasBean.getEstatusRem()));
									sentenciaStore.setString("Par_UsuarioEnvio", remesasBean.getUsuarioEnvio());
									sentenciaStore.setInt("Par_AreaEmiteID", Utileria.convierteEntero(remesasBean.getAreaEmiteID()));
									sentenciaStore.setString("Par_FechaRecepcion", remesasBean.getFechaRecepcion());
									sentenciaStore.setInt("Par_CausaDevol", Utileria.convierteEntero(remesasBean.getCausaDevol()));

									sentenciaStore.setString("Par_Topologia", STRING_TOPOT);
									sentenciaStore.setInt("Par_Folio", Utileria.convierteEntero(remesasBean.getFolio()));
									sentenciaStore.setInt("Par_FolioPaquete", Utileria.convierteEntero(remesasBean.getFolioPaquete()));
									sentenciaStore.setInt("Par_FolioServidor", Utileria.convierteEntero(remesasBean.getFolioServidor()));
									sentenciaStore.setString("Par_Firma", remesasBean.getFirma());
									sentenciaStore.setInt("Par_RemesaWSID", Constantes.ENTERO_CERO);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID", getParametrosAuditoriaBean().getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", getParametrosAuditoriaBean().getUsuario());
									sentenciaStore.setString("Aud_FechaActual", Utileria.convierteFecha(Utileria.consultaFechaHoraServidor()));
									sentenciaStore.setString("Aud_DireccionIP", getParametrosAuditoriaBean().getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "RemesasDAO.altaRemesasPro");
									sentenciaStore.setInt("Aud_Sucursal", getParametrosAuditoriaBean().getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", getParametrosAuditoriaBean().getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(resultadosStore.getInt("NumErr"));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " RemesasDAO.altaRemesa");
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
						throw new Exception(Constantes.MSG_ERROR + " RemesasDAO.altaRemesa");
					} else if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+" Error al dar de alta la remesa" + e);
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
}