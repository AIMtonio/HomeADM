package pld.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import pld.bean.OpeInusualesBean;

public class BitacoraHistPersDAO extends BaseDAO{
	public MensajeTransaccionBean alta(final OpeInusualesBean opeInusualesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccionOpeInusuales(opeInusualesBean.getOrigenDatos());
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(opeInusualesBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(opeInusualesBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							/*---------------Query con el SP-------------*/
							String query = "call BITACORAHISTPERSALT("
									+ "?,?,?,?,?,   "
									+ "?,?,?,?,?,   "
									+ "?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							/* Object[] parametros = { */
							sentenciaStore.setString("Par_CatProcedIntID", opeInusualesBean.getCatProcedIntID());
							sentenciaStore.setString("Par_CatMotivInuID", opeInusualesBean.getCatMotivInuID());
							sentenciaStore.setDate("Par_FechaDeteccion", OperacionesFechas.conversionStrDate(opeInusualesBean.getFechaDeteccion()));
							sentenciaStore.setInt("Par_ClavePersonaInv", Utileria.convierteEntero(opeInusualesBean.getClavePersonaInv()));
							sentenciaStore.setString("Par_NomPersonaInv", opeInusualesBean.getNomPersonaInv());

							sentenciaStore.setString("Par_EmpInvolucrado", opeInusualesBean.getEmpInvolucrado());
							sentenciaStore.setString("Par_Frecuencia", opeInusualesBean.getFrecuencia());
							sentenciaStore.setString("Par_DesFrecuencia", opeInusualesBean.getDesFrecuencia());
							sentenciaStore.setString("Par_DesOperacion", opeInusualesBean.getDesOperacion());
							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(opeInusualesBean.getCreditoID()));

							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(opeInusualesBean.getCuentaAhoID()));
							sentenciaStore.setInt("Par_TransaccionOpe", Utileria.convierteEntero(opeInusualesBean.getTransaccionOpe()));
							sentenciaStore.setInt("Par_NaturaOperacion", Utileria.convierteEntero(opeInusualesBean.getNaturaOperacion()));
							sentenciaStore.setDouble("Par_MontoOperacion", Utileria.convierteEntero(opeInusualesBean.getMontoOperacion()));
							sentenciaStore.setInt("Par_MonedaOperacion", Utileria.convierteEntero(opeInusualesBean.getMonedaID()));

							sentenciaStore.setString("Par_TipoPersonaSAFI", opeInusualesBean.getTipoPerSAFI());
							sentenciaStore.setString("Par_NombresPersonaInv", opeInusualesBean.getNombresPersonaInv());
							sentenciaStore.setString("Par_ApPaternoPersonaInv", opeInusualesBean.getApPaternoPersonaInv());
							sentenciaStore.setString("Par_ApMaternoPersonaInv", opeInusualesBean.getApMaternoPersonaInv());
							sentenciaStore.setString("Par_TipoListaID", Constantes.STRING_VACIO);
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);

							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Aud_EmpresaID", Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);

							sentenciaStore.setString("Aud_DireccionIP", Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID", Constantes.STRING_VACIO);
							sentenciaStore.setInt("Aud_Sucursal", Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion", Constantes.ENTERO_CERO);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta  de operacionesinusuales", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
}
