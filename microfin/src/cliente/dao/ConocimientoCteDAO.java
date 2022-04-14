package cliente.dao;
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

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import cliente.bean.ConocimientoCteBean;

public class ConocimientoCteDAO extends BaseDAO {
	public ConocimientoCteDAO() {
		super();
	}

	/* Alta de conocimiento del cliente */
	public MensajeTransaccionBean altaConocimiento(final ConocimientoCteBean conocimiento) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					conocimiento.setTelefonoRef(conocimiento.getTelefonoRef().trim().replaceAll("\\(", "").replaceAll("\\)", "").replaceAll(" ", "").replaceAll("\\-", ""));
					conocimiento.setTelefonoRef2(conocimiento.getTelefonoRef2().trim().replaceAll("\\(", "").replaceAll("\\)", "").replaceAll(" ", "").replaceAll("\\-", ""));
					conocimiento.setTelRefCom(conocimiento.getTelRefCom().trim().replaceAll("\\(", "").replaceAll("\\)", "").replaceAll(" ", "").replaceAll("\\-", ""));
					conocimiento.setTelRefCom2(conocimiento.getTelRefCom2().trim().replaceAll("\\(", "").replaceAll("\\)", "").replaceAll(" ", "").replaceAll("\\-", ""));
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CONOCIMIENTOCTEALT("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(conocimiento.getClienteID()));
							sentenciaStore.setString("Par_NomGrupo", conocimiento.getNomGrupo());
							sentenciaStore.setString("Par_RFC", conocimiento.getRFC());
							sentenciaStore.setDouble("Par_Particip", Utileria.convierteDoble(conocimiento.getParticipacion()));
							sentenciaStore.setString("Par_Nacional", conocimiento.getNacionalidad());

							sentenciaStore.setString("Par_RazonSocial", conocimiento.getRazonSocial());
							sentenciaStore.setString("Par_Giro", conocimiento.getGiro());
							sentenciaStore.setString("Par_PEPs", conocimiento.getPEPs());
							sentenciaStore.setInt("Par_FuncionID", Utileria.convierteEntero(conocimiento.getFuncionID()));
							sentenciaStore.setString("Par_ParentesPEP", conocimiento.getParentescoPEP());

							sentenciaStore.setString("Par_NombFam", conocimiento.getNombFamiliar());
							sentenciaStore.setString("Par_aPaternoFam", conocimiento.getaPaternoFam());
							sentenciaStore.setString("Par_aMaternoFam", conocimiento.getaMaternoFam());
							sentenciaStore.setString("Par_NoEmpleados", conocimiento.getNoEmpleados());
							sentenciaStore.setString("Par_Serv_Produc", conocimiento.getServ_Produc());

							sentenciaStore.setString("Par_Cober_Geog", conocimiento.getCober_Geograf());
							sentenciaStore.setString("Par_Edos_Presen", conocimiento.getEstados_Presen());
							sentenciaStore.setDouble("Par_ImporteVta", Utileria.convierteDoble(conocimiento.getImporteVta()));
							sentenciaStore.setDouble("Par_Activos", Utileria.convierteDoble(conocimiento.getActivos()));
							sentenciaStore.setDouble("Par_Pasivos", Utileria.convierteDoble(conocimiento.getPasivos()));

							sentenciaStore.setDouble("Par_Capital", Utileria.convierteDoble(conocimiento.getCapital()));
							sentenciaStore.setString("Par_Importa", conocimiento.getImporta());
							sentenciaStore.setString("Par_DolImport", conocimiento.getDolaresImport());
							sentenciaStore.setString("Par_PaisImport", conocimiento.getPaisesImport());
							sentenciaStore.setString("Par_PaisImport2", conocimiento.getPaisesImport2());

							sentenciaStore.setString("Par_PaisImport3", conocimiento.getPaisesImport3());
							sentenciaStore.setString("Par_Exporta", conocimiento.getExporta());
							sentenciaStore.setString("Par_DolExport", conocimiento.getDolaresExport());
							sentenciaStore.setString("Par_PaisExport", conocimiento.getPaisesExport());
							sentenciaStore.setString("Par_PaisExport2", conocimiento.getPaisesExport2());

							sentenciaStore.setString("Par_PaisExport3", conocimiento.getPaisesExport3());
							sentenciaStore.setString("Par_NombRefCom", conocimiento.getNombRefCom());
							sentenciaStore.setString("Par_NombRefCom2", conocimiento.getNombRefCom2());
							sentenciaStore.setString("Par_TelRefCom", conocimiento.getTelRefCom());
							sentenciaStore.setString("Par_TelRefCom2", conocimiento.getTelRefCom2());

							sentenciaStore.setString("Par_BancoRef", conocimiento.getBancoRef());
							sentenciaStore.setString("Par_BancoRef2", conocimiento.getBancoRef2());
							sentenciaStore.setString("Par_NoCtaRef", conocimiento.getNoCuentaRef());
							sentenciaStore.setString("Par_NoCtaRef2", conocimiento.getNoCuentaRef2());
							sentenciaStore.setString("Par_NombreRef", conocimiento.getNombreRef());

							sentenciaStore.setString("Par_NombreRef2", conocimiento.getNombreRef2());
							sentenciaStore.setString("Par_DomRef", conocimiento.getDomicilioRef());
							sentenciaStore.setString("Par_DomRef2", conocimiento.getDomicilioRef2());
							sentenciaStore.setString("Par_TelRef", conocimiento.getTelefonoRef());
							sentenciaStore.setString("Par_TelRef2", conocimiento.getTelefonoRef2());

							sentenciaStore.setString("Par_pFteIng", conocimiento.getpFuenteIng());
							sentenciaStore.setString("Par_IngAproxMes", conocimiento.getIngAproxMes());
							sentenciaStore.setString("Par_ExtTelRef1", conocimiento.getExtTelefonoRefUno());
							sentenciaStore.setString("Par_ExtTelRef2", conocimiento.getExtTelefonoRefDos());
							sentenciaStore.setString("Par_ExtTelRefCom", conocimiento.getExtTelRefCom());

							sentenciaStore.setString("Par_ExtTelRefCom2", conocimiento.getExtTelRefCom2());
							sentenciaStore.setInt("Par_Relacion1", Utileria.convierteEntero(conocimiento.getTipoRelacion1()));
							sentenciaStore.setInt("Par_Relacion2", Utileria.convierteEntero(conocimiento.getTipoRelacion2()));
							sentenciaStore.setString("Par_PregUno", conocimiento.getPreguntaCte1());
							sentenciaStore.setString("Par_RespUno", conocimiento.getRespuestaCte1());

							sentenciaStore.setString("Par_PregDos", conocimiento.getPreguntaCte2());
							sentenciaStore.setString("Par_RespDos", conocimiento.getRespuestaCte2());
							sentenciaStore.setString("Par_PregTres", conocimiento.getPreguntaCte3());
							sentenciaStore.setString("Par_RespTres", conocimiento.getRespuestaCte3());
							sentenciaStore.setString("Par_PregCuatro", conocimiento.getPreguntaCte4());

							sentenciaStore.setString("Par_RespCuatro", conocimiento.getRespuestaCte4());
							sentenciaStore.setDouble("Par_CapitalContable", Utileria.convierteDoble(conocimiento.getCapitalContable()));
							sentenciaStore.setString("Par_NivelRiesgo", conocimiento.getNivelRiesgo());
							sentenciaStore.setString("Par_EvaluaXMatriz", conocimiento.getEvaluaXMatriz());
							sentenciaStore.setString("Par_ComentarioNivel", conocimiento.getComentarioNivel());

							sentenciaStore.setString("Par_NoCuentaRefCom", conocimiento.getNoCuentaRefCom());
							sentenciaStore.setString("Par_NoCuentaRefCom2", conocimiento.getNoCuentaRefCom2());
							sentenciaStore.setString("Par_DireccionRefCom", conocimiento.getDireccionRefCom());
							sentenciaStore.setString("Par_DireccionRefCom2", conocimiento.getDireccionRefCom2());
							sentenciaStore.setString("Par_BanTipoCuentaRef", conocimiento.getBanTipoCuentaRef());

							sentenciaStore.setString("Par_BanTipoCuentaRef2", conocimiento.getBanTipoCuentaRef2());
							sentenciaStore.setString("Par_BanSucursalRef", conocimiento.getBanSucursalRef());
							sentenciaStore.setString("Par_BanSucursalRef2", conocimiento.getBanSucursalRef2());
							sentenciaStore.setString("Par_BanNoTarjetaRef", conocimiento.getBanNoTarjetaRef());
							sentenciaStore.setString("Par_BanNoTarjetaRef2", conocimiento.getBanNoTarjetaRef2());

							sentenciaStore.setString("Par_BanTarjetaInsRef", conocimiento.getBanTarjetaInsRef());
							sentenciaStore.setString("Par_BanTarjetaInsRef2", conocimiento.getBanTarjetaInsRef2());
							sentenciaStore.setString("Par_BanCredOtraEnt", conocimiento.getBanCredOtraEnt());
							sentenciaStore.setString("Par_BanCredOtraEnt2", conocimiento.getBanCredOtraEnt2());
							sentenciaStore.setString("Par_BanInsOtraEnt", conocimiento.getBanInsOtraEnt());

							sentenciaStore.setString("Par_BanInsOtraEnt2", conocimiento.getBanInsOtraEnt2());
							sentenciaStore.setString("Par_FechaNombramiento", Utileria.convierteFecha(conocimiento.getFechaNombramiento()));
							sentenciaStore.setString("Par_PeriodoCargo", conocimiento.getPeriodoCargo());
							sentenciaStore.setDouble("Par_PorcentajeAcciones", Utileria.convierteDoble(conocimiento.getPorcentajeAcciones()));
							sentenciaStore.setDouble("Par_MontoAcciones", Utileria.convierteDoble(conocimiento.getMontoAcciones()));

							sentenciaStore.setString("Par_TiposClientes", conocimiento.getTiposClientes());
							sentenciaStore.setString("Par_InstrumentosMonetarios", conocimiento.getInstrumentosMonetarios());
							sentenciaStore.setString("Par_OperacionAnios", conocimiento.getOperacionAnios());
							sentenciaStore.setString("Par_GiroAnios",conocimiento.getGiroAnios());
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);

							sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "ConocimientoCteDAO.altaConocimiento");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

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
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ConocimientoCteDAO.altaConocimiento");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ConocimientoCteDAO.altaConocimiento");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de conocimiento de cliente", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*Utilizado para WS*/
	public MensajeTransaccionBean altaConocimientoWS(final ConocimientoCteBean conocimiento) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					conocimiento.setTelefonoRef(conocimiento.getTelefonoRef().trim().replaceAll("\\(", "").replaceAll("\\)", "").replaceAll(" ", "").replaceAll("\\-", ""));
					conocimiento.setTelefonoRef2(conocimiento.getTelefonoRef2().trim().replaceAll("\\(", "").replaceAll("\\)", "").replaceAll(" ", "").replaceAll("\\-", ""));
					conocimiento.setTelRefCom(conocimiento.getTelRefCom().trim().replaceAll("\\(", "").replaceAll("\\)", "").replaceAll(" ", "").replaceAll("\\-", ""));
					conocimiento.setTelRefCom2(conocimiento.getTelRefCom2().trim().replaceAll("\\(", "").replaceAll("\\)", "").replaceAll(" ", "").replaceAll("\\-", ""));
					//Query con el Store Procedure

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CONOCIMIENTOCTEALT("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(conocimiento.getClienteID()));
							sentenciaStore.setString("Par_NomGrupo", conocimiento.getNomGrupo());
							sentenciaStore.setString("Par_RFC", conocimiento.getRFC());
							sentenciaStore.setDouble("Par_Particip", Utileria.convierteDoble(conocimiento.getParticipacion()));
							sentenciaStore.setString("Par_Nacional", conocimiento.getNacionalidad());

							sentenciaStore.setString("Par_RazonSocial", conocimiento.getRazonSocial());
							sentenciaStore.setString("Par_Giro", conocimiento.getGiro());
							sentenciaStore.setString("Par_PEPs", conocimiento.getPEPs());
							sentenciaStore.setInt("Par_FuncionID", Utileria.convierteEntero(conocimiento.getFuncionID()));
							sentenciaStore.setString("Par_ParentesPEP", conocimiento.getParentescoPEP());

							sentenciaStore.setString("Par_NombFam", conocimiento.getNombFamiliar());
							sentenciaStore.setString("Par_aPaternoFam", conocimiento.getaPaternoFam());
							sentenciaStore.setString("Par_aMaternoFam", conocimiento.getaMaternoFam());
							sentenciaStore.setString("Par_NoEmpleados", conocimiento.getNoEmpleados());
							sentenciaStore.setString("Par_Serv_Produc", conocimiento.getServ_Produc());

							sentenciaStore.setString("Par_Cober_Geog", conocimiento.getCober_Geograf());
							sentenciaStore.setString("Par_Edos_Presen", conocimiento.getEstados_Presen());
							sentenciaStore.setDouble("Par_ImporteVta", Utileria.convierteDoble(conocimiento.getImporteVta()));
							sentenciaStore.setDouble("Par_Activos", Utileria.convierteDoble(conocimiento.getActivos()));
							sentenciaStore.setDouble("Par_Pasivos", Utileria.convierteDoble(conocimiento.getPasivos()));

							sentenciaStore.setDouble("Par_Capital", Utileria.convierteDoble(conocimiento.getCapital()));
							sentenciaStore.setString("Par_Importa", conocimiento.getImporta());
							sentenciaStore.setString("Par_DolImport", conocimiento.getDolaresImport());
							sentenciaStore.setString("Par_PaisImport", conocimiento.getPaisesImport());
							sentenciaStore.setString("Par_PaisImport2", conocimiento.getPaisesImport2());

							sentenciaStore.setString("Par_PaisImport3", conocimiento.getPaisesImport3());
							sentenciaStore.setString("Par_Exporta", conocimiento.getExporta());
							sentenciaStore.setString("Par_DolExport", conocimiento.getDolaresExport());
							sentenciaStore.setString("Par_PaisExport", conocimiento.getPaisesExport());
							sentenciaStore.setString("Par_PaisExport2", conocimiento.getPaisesExport2());

							sentenciaStore.setString("Par_PaisExport3", conocimiento.getPaisesExport3());
							sentenciaStore.setString("Par_NombRefCom", conocimiento.getNombRefCom());
							sentenciaStore.setString("Par_NombRefCom2", conocimiento.getNombRefCom2());
							sentenciaStore.setString("Par_TelRefCom", conocimiento.getTelRefCom());
							sentenciaStore.setString("Par_TelRefCom2", conocimiento.getTelRefCom2());

							sentenciaStore.setString("Par_BancoRef", conocimiento.getBancoRef());
							sentenciaStore.setString("Par_BancoRef2", conocimiento.getBancoRef2());
							sentenciaStore.setString("Par_NoCtaRef", conocimiento.getNoCuentaRef());
							sentenciaStore.setString("Par_NoCtaRef2", conocimiento.getNoCuentaRef2());
							sentenciaStore.setString("Par_NombreRef", conocimiento.getNombreRef());

							sentenciaStore.setString("Par_NombreRef2", conocimiento.getNombreRef2());
							sentenciaStore.setString("Par_DomRef", conocimiento.getDomicilioRef());
							sentenciaStore.setString("Par_DomRef2", conocimiento.getDomicilioRef2());
							sentenciaStore.setString("Par_TelRef", conocimiento.getTelefonoRef());
							sentenciaStore.setString("Par_TelRef2", conocimiento.getTelefonoRef2());

							sentenciaStore.setString("Par_pFteIng", conocimiento.getpFuenteIng());
							sentenciaStore.setString("Par_IngAproxMes", conocimiento.getIngAproxMes());
							sentenciaStore.setString("Par_ExtTelRef1", conocimiento.getExtTelefonoRefUno());
							sentenciaStore.setString("Par_ExtTelRef2", conocimiento.getExtTelefonoRefDos());
							sentenciaStore.setString("Par_ExtTelRefCom", conocimiento.getExtTelRefCom());

							sentenciaStore.setString("Par_ExtTelRefCom2", conocimiento.getExtTelRefCom2());
							sentenciaStore.setInt("Par_Relacion1", Utileria.convierteEntero(conocimiento.getTipoRelacion1()));
							sentenciaStore.setInt("Par_Relacion2", Utileria.convierteEntero(conocimiento.getTipoRelacion2()));
							sentenciaStore.setString("Par_PregUno", Constantes.STRING_VACIO);
							sentenciaStore.setString("Par_RespUno", Constantes.STRING_VACIO);

							sentenciaStore.setString("Par_PregDos", Constantes.STRING_VACIO);
							sentenciaStore.setString("Par_RespDos", Constantes.STRING_VACIO);
							sentenciaStore.setString("Par_PregTres", Constantes.STRING_VACIO);
							sentenciaStore.setString("Par_RespTres", Constantes.STRING_VACIO);
							sentenciaStore.setString("Par_PregCuatro", Constantes.STRING_VACIO);

							sentenciaStore.setString("Par_RespCuatro", Constantes.STRING_VACIO);
							sentenciaStore.setDouble("Par_CapitalContable", Utileria.convierteDoble(conocimiento.getCapitalContable()));
							sentenciaStore.setString("Par_NivelRiesgo", conocimiento.getNivelRiesgo());
							sentenciaStore.setString("Par_EvaluaXMatriz", conocimiento.getEvaluaXMatriz());
							sentenciaStore.setString("Par_ComentarioNivel", conocimiento.getComentarioNivel());

							sentenciaStore.setString("Par_NoCuentaRefCom", conocimiento.getNoCuentaRefCom());
							sentenciaStore.setString("Par_NoCuentaRefCom2", conocimiento.getNoCuentaRefCom2());
							sentenciaStore.setString("Par_DireccionRefCom", conocimiento.getDireccionRefCom());
							sentenciaStore.setString("Par_DireccionRefCom2", conocimiento.getDireccionRefCom2());
							sentenciaStore.setString("Par_BanTipoCuentaRef", conocimiento.getBanTipoCuentaRef());

							sentenciaStore.setString("Par_BanTipoCuentaRef2", conocimiento.getBanTipoCuentaRef2());
							sentenciaStore.setString("Par_BanSucursalRef", conocimiento.getBanSucursalRef());
							sentenciaStore.setString("Par_BanSucursalRef2", conocimiento.getBanSucursalRef2());
							sentenciaStore.setString("Par_BanNoTarjetaRef", conocimiento.getBanNoTarjetaRef());
							sentenciaStore.setString("Par_BanNoTarjetaRef2", conocimiento.getBanNoTarjetaRef2());

							sentenciaStore.setString("Par_BanTarjetaInsRef", conocimiento.getBanTarjetaInsRef());
							sentenciaStore.setString("Par_BanTarjetaInsRef2", conocimiento.getBanTarjetaInsRef2());
							sentenciaStore.setString("Par_BanCredOtraEnt", conocimiento.getBanCredOtraEnt());
							sentenciaStore.setString("Par_BanCredOtraEnt2", conocimiento.getBanCredOtraEnt2());
							sentenciaStore.setString("Par_BanInsOtraEnt", conocimiento.getBanInsOtraEnt());

							sentenciaStore.setString("Par_BanInsOtraEnt2", conocimiento.getBanInsOtraEnt2());
							sentenciaStore.setString("Par_FechaNombramiento", Utileria.convierteFecha(conocimiento.getFechaNombramiento()));
							sentenciaStore.setString("Par_PeriodoCargo", conocimiento.getPeriodoCargo());
							sentenciaStore.setDouble("Par_PorcentajeAcciones", Utileria.convierteDoble(conocimiento.getPorcentajeAcciones()));
							sentenciaStore.setDouble("Par_MontoAcciones", Utileria.convierteDoble(conocimiento.getMontoAcciones()));

							sentenciaStore.setString("Par_TiposClientes", conocimiento.getTiposClientes());
							sentenciaStore.setString("Par_InstrumentosMonetarios", conocimiento.getInstrumentosMonetarios());
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.CHAR);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "ConocimientoCteDAO.altaConocimiento");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

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
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ConocimientoCteDAO.altaConocimiento");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ConocimientoCteDAO.altaConocimiento");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de conocimiento de cliente", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Modificación de conocimiento del cliente */
	public MensajeTransaccionBean modificaConocimiento(final ConocimientoCteBean conocimiento) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					conocimiento.setTelefonoRef(conocimiento.getTelefonoRef().trim().replaceAll("\\(", "").replaceAll("\\)", "").replaceAll(" ", "").replaceAll("\\-", ""));
					conocimiento.setTelefonoRef2(conocimiento.getTelefonoRef2().trim().replaceAll("\\(", "").replaceAll("\\)", "").replaceAll(" ", "").replaceAll("\\-", ""));
					conocimiento.setTelRefCom(conocimiento.getTelRefCom().trim().replaceAll("\\(", "").replaceAll("\\)", "").replaceAll(" ", "").replaceAll("\\-", ""));
					conocimiento.setTelRefCom2(conocimiento.getTelRefCom2().trim().replaceAll("\\(", "").replaceAll("\\)", "").replaceAll(" ", "").replaceAll("\\-", ""));
					//Query con el Store Procedure

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CONOCIMIENTOCTEMOD("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"

									+ "?,?,?,?,?,		"
									+ "?,?,?,?);";


							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(conocimiento.getClienteID()));
							sentenciaStore.setString("Par_NomGrupo", conocimiento.getNomGrupo());
							sentenciaStore.setString("Par_RFC", conocimiento.getRFC());
							sentenciaStore.setDouble("Par_Particip", Utileria.convierteDoble(conocimiento.getParticipacion()));
							sentenciaStore.setString("Par_Nacional", conocimiento.getNacionalidad());

							sentenciaStore.setString("Par_RazonSocial", conocimiento.getRazonSocial());
							sentenciaStore.setString("Par_Giro", conocimiento.getGiro());
							sentenciaStore.setString("Par_PEPs", conocimiento.getPEPs());
							sentenciaStore.setInt("Par_FuncionID", Utileria.convierteEntero(conocimiento.getFuncionID()));
							sentenciaStore.setString("Par_ParentesPEP", conocimiento.getParentescoPEP());

							sentenciaStore.setString("Par_NombFam", conocimiento.getNombFamiliar());
							sentenciaStore.setString("Par_aPaternoFam", conocimiento.getaPaternoFam());
							sentenciaStore.setString("Par_aMaternoFam", conocimiento.getaMaternoFam());
							sentenciaStore.setString("Par_NoEmpleados", conocimiento.getNoEmpleados());
							sentenciaStore.setString("Par_Serv_Produc", conocimiento.getServ_Produc());

							sentenciaStore.setString("Par_Cober_Geog", conocimiento.getCober_Geograf());
							sentenciaStore.setString("Par_Edos_Presen", conocimiento.getEstados_Presen());
							sentenciaStore.setDouble("Par_ImporteVta", Utileria.convierteDoble(conocimiento.getImporteVta()));
							sentenciaStore.setDouble("Par_Activos", Utileria.convierteDoble(conocimiento.getActivos()));
							sentenciaStore.setDouble("Par_Pasivos", Utileria.convierteDoble(conocimiento.getPasivos()));

							sentenciaStore.setDouble("Par_Capital", Utileria.convierteDoble(conocimiento.getCapital()));
							sentenciaStore.setString("Par_Importa", conocimiento.getImporta());
							sentenciaStore.setString("Par_DolImport", conocimiento.getDolaresImport());
							sentenciaStore.setString("Par_PaisImport", conocimiento.getPaisesImport());
							sentenciaStore.setString("Par_PaisImport2", conocimiento.getPaisesImport2());

							sentenciaStore.setString("Par_PaisImport3", conocimiento.getPaisesImport3());
							sentenciaStore.setString("Par_Exporta", conocimiento.getExporta());
							sentenciaStore.setString("Par_DolExport", conocimiento.getDolaresExport());
							sentenciaStore.setString("Par_PaisExport", conocimiento.getPaisesExport());
							sentenciaStore.setString("Par_PaisExport2", conocimiento.getPaisesExport2());

							sentenciaStore.setString("Par_PaisExport3", conocimiento.getPaisesExport3());
							sentenciaStore.setString("Par_NombRefCom", conocimiento.getNombRefCom());
							sentenciaStore.setString("Par_NombRefCom2", conocimiento.getNombRefCom2());
							sentenciaStore.setString("Par_TelRefCom", conocimiento.getTelRefCom());
							sentenciaStore.setString("Par_TelRefCom2", conocimiento.getTelRefCom2());

							sentenciaStore.setString("Par_BancoRef", conocimiento.getBancoRef());
							sentenciaStore.setString("Par_BancoRef2", conocimiento.getBancoRef2());
							sentenciaStore.setString("Par_NoCtaRef", conocimiento.getNoCuentaRef());
							sentenciaStore.setString("Par_NoCtaRef2", conocimiento.getNoCuentaRef2());
							sentenciaStore.setString("Par_NombreRef", conocimiento.getNombreRef());

							sentenciaStore.setString("Par_NombreRef2", conocimiento.getNombreRef2());
							sentenciaStore.setString("Par_DomRef", conocimiento.getDomicilioRef());
							sentenciaStore.setString("Par_DomRef2", conocimiento.getDomicilioRef2());
							sentenciaStore.setString("Par_TelRef", conocimiento.getTelefonoRef());
							sentenciaStore.setString("Par_TelRef2", conocimiento.getTelefonoRef2());

							sentenciaStore.setString("Par_pFteIng", conocimiento.getpFuenteIng());
							sentenciaStore.setString("Par_IngAproxMes", conocimiento.getIngAproxMes());
							sentenciaStore.setString("Par_ExtTelRef1", conocimiento.getExtTelefonoRefUno());
							sentenciaStore.setString("Par_ExtTelRef2", conocimiento.getExtTelefonoRefDos());
							sentenciaStore.setString("Par_ExtTelRefCom", conocimiento.getExtTelRefCom());

							sentenciaStore.setString("Par_ExtTelRefCom2", conocimiento.getExtTelRefCom2());
							sentenciaStore.setInt("Par_Relacion1", Utileria.convierteEntero(conocimiento.getTipoRelacion1()));
							sentenciaStore.setInt("Par_Relacion2", Utileria.convierteEntero(conocimiento.getTipoRelacion2()));
							sentenciaStore.setString("Par_PregUno", conocimiento.getPreguntaCte1());
							sentenciaStore.setString("Par_RespUno", conocimiento.getRespuestaCte1());

							sentenciaStore.setString("Par_PregDos", conocimiento.getPreguntaCte2());
							sentenciaStore.setString("Par_RespDos", conocimiento.getRespuestaCte2());
							sentenciaStore.setString("Par_PregTres", conocimiento.getPreguntaCte3());
							sentenciaStore.setString("Par_RespTres", conocimiento.getRespuestaCte3());
							sentenciaStore.setString("Par_PregCuatro", conocimiento.getPreguntaCte4());

							sentenciaStore.setString("Par_RespCuatro", conocimiento.getRespuestaCte4());
							sentenciaStore.setDouble("Par_CapitalContable", Utileria.convierteDoble(conocimiento.getCapitalContable()));
							sentenciaStore.setString("Par_NivelRiesgo", conocimiento.getNivelRiesgo());
							sentenciaStore.setString("Par_EvaluaXMatriz", conocimiento.getEvaluaXMatriz());
							sentenciaStore.setString("Par_ComentarioNivel", conocimiento.getComentarioNivel());

							sentenciaStore.setString("Par_NoCuentaRefCom", conocimiento.getNoCuentaRefCom());
							sentenciaStore.setString("Par_NoCuentaRefCom2", conocimiento.getNoCuentaRefCom2());
							sentenciaStore.setString("Par_DireccionRefCom", conocimiento.getDireccionRefCom());
							sentenciaStore.setString("Par_DireccionRefCom2", conocimiento.getDireccionRefCom2());
							sentenciaStore.setString("Par_BanTipoCuentaRef", conocimiento.getBanTipoCuentaRef());

							sentenciaStore.setString("Par_BanTipoCuentaRef2", conocimiento.getBanTipoCuentaRef2());
							sentenciaStore.setString("Par_BanSucursalRef", conocimiento.getBanSucursalRef());
							sentenciaStore.setString("Par_BanSucursalRef2", conocimiento.getBanSucursalRef2());
							sentenciaStore.setString("Par_BanNoTarjetaRef", conocimiento.getBanNoTarjetaRef());
							sentenciaStore.setString("Par_BanNoTarjetaRef2", conocimiento.getBanNoTarjetaRef2());

							sentenciaStore.setString("Par_BanTarjetaInsRef", conocimiento.getBanTarjetaInsRef());
							sentenciaStore.setString("Par_BanTarjetaInsRef2", conocimiento.getBanTarjetaInsRef2());
							sentenciaStore.setString("Par_BanCredOtraEnt", conocimiento.getBanCredOtraEnt());
							sentenciaStore.setString("Par_BanCredOtraEnt2", conocimiento.getBanCredOtraEnt2());
							sentenciaStore.setString("Par_BanInsOtraEnt", conocimiento.getBanInsOtraEnt());

							sentenciaStore.setString("Par_BanInsOtraEnt2", conocimiento.getBanInsOtraEnt2());
							sentenciaStore.setString("Par_FechaNombramiento", Utileria.convierteFecha(conocimiento.getFechaNombramiento()));
							sentenciaStore.setString("Par_PeriodoCargo", conocimiento.getPeriodoCargo());
							sentenciaStore.setDouble("Par_PorcentajeAcciones", Utileria.convierteDoble(conocimiento.getPorcentajeAcciones()));
							sentenciaStore.setDouble("Par_MontoAcciones", Utileria.convierteDoble(conocimiento.getMontoAcciones()));

							sentenciaStore.setString("Par_TiposClientes", conocimiento.getTiposClientes());
							sentenciaStore.setString("Par_InstrumentosMonetarios", conocimiento.getInstrumentosMonetarios());
							sentenciaStore.setString("Par_OperacionAnios", conocimiento.getOperacionAnios());
							sentenciaStore.setString("Par_GiroAnios", conocimiento.getGiroAnios());
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);

							sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "ConocimientoCteDAO.modificaConocimiento");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

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
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ConocimientoCteDAO.modificaConocimiento");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ConocimientoCteDAO.modificaConocimiento");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error al modificar el conocimiento del cliente", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Consuta Conocimiento del Cliente por Llave Principal*/
	public ConocimientoCteBean consultaPrincipal(ConocimientoCteBean conocimiento, int tipoConsulta) {
		String query = "call CONOCIMIENTOCTECON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {conocimiento.getClienteID(), tipoConsulta, Constantes.ENTERO_CERO, Constantes.ENTERO_CERO, Constantes.FECHA_VACIA, Constantes.STRING_VACIO, "ConocimientoCteDAO.consultaPrincipal", Constantes.ENTERO_CERO, Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CONOCIMIENTOCTECON(" + Arrays.toString(parametros) + ")");

		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				ConocimientoCteBean conocimiento = new ConocimientoCteBean();

				conocimiento.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));
				conocimiento.setNomGrupo(resultSet.getString("NomGrupo"));
				conocimiento.setRFC(resultSet.getString("RFC"));
				conocimiento.setParticipacion(resultSet.getString("Participacion"));
				conocimiento.setNacionalidad(resultSet.getString("Nacionalidad"));

				conocimiento.setRazonSocial(resultSet.getString("RazonSocial"));
				conocimiento.setGiro(resultSet.getString("Giro"));
				conocimiento.setPEPs(resultSet.getString("PEPs"));
				conocimiento.setFuncionID(String.valueOf(resultSet.getInt("FuncionID")));
				conocimiento.setParentescoPEP(resultSet.getString("ParentescoPEP"));

				conocimiento.setNombFamiliar(resultSet.getString("NombFamiliar"));
				conocimiento.setaPaternoFam(resultSet.getString("APaternoFam"));
				conocimiento.setaMaternoFam(resultSet.getString("AMaternoFam"));
				conocimiento.setNoEmpleados(resultSet.getString("NoEmpleados"));
				conocimiento.setServ_Produc(resultSet.getString("Serv_Produc"));

				conocimiento.setCober_Geograf(resultSet.getString("Cober_Geograf"));
				conocimiento.setEstados_Presen(resultSet.getString("Estados_Presen"));
				conocimiento.setImporteVta(resultSet.getString("ImporteVta"));
				conocimiento.setActivos(resultSet.getString("Activos"));
				conocimiento.setPasivos(resultSet.getString("Pasivos"));

				conocimiento.setCapital(resultSet.getString("Capital"));
				conocimiento.setImporta(resultSet.getString("Importa"));
				conocimiento.setDolaresImport(resultSet.getString("DolaresImport"));
				conocimiento.setPaisesImport(resultSet.getString("PaisesImport"));
				conocimiento.setPaisesImport2(resultSet.getString("PaisesImport2"));

				conocimiento.setPaisesImport3(resultSet.getString("PaisesImport3"));
				conocimiento.setExporta(resultSet.getString("Exporta"));
				conocimiento.setDolaresExport(resultSet.getString("DolaresExport"));
				conocimiento.setPaisesExport(resultSet.getString("PaisesExport"));
				conocimiento.setPaisesExport2(resultSet.getString("PaisesExport2"));

				conocimiento.setPaisesExport3(resultSet.getString("PaisesExport3"));
				conocimiento.setNombRefCom(resultSet.getString("NombRefCom"));
				conocimiento.setNombRefCom2(resultSet.getString("NombRefCom2"));
				conocimiento.setTelRefCom(resultSet.getString("TelRefCom"));
				conocimiento.setTelRefCom2(resultSet.getString("TelRefCom2"));

				conocimiento.setBancoRef(resultSet.getString("BancoRef"));
				conocimiento.setBancoRef2(resultSet.getString("BancoRef2"));
				conocimiento.setNoCuentaRef(resultSet.getString("NoCuentaRef"));
				conocimiento.setNoCuentaRef2(resultSet.getString("NoCuentaRef2"));
				conocimiento.setNombreRef(resultSet.getString("NombreRef"));

				conocimiento.setNombreRef2(resultSet.getString("NombreRef2"));
				conocimiento.setDomicilioRef(resultSet.getString("DomicilioRef"));
				conocimiento.setDomicilioRef2(resultSet.getString("DomicilioRef2"));
				conocimiento.setTelefonoRef(resultSet.getString("TelefonoRef"));
				conocimiento.setTelefonoRef2(resultSet.getString("TelefonoRef2"));

				conocimiento.setpFuenteIng(resultSet.getString("PFuenteIng"));
				conocimiento.setIngAproxMes(resultSet.getString("IngAproxMes"));
				conocimiento.setExtTelefonoRefUno(resultSet.getString("ExtTelefonoRefUno"));
				conocimiento.setExtTelefonoRefDos(resultSet.getString("ExtTelefonoRefDos"));
				conocimiento.setExtTelRefCom(resultSet.getString("ExtTelRefCom"));

				conocimiento.setExtTelRefCom2(resultSet.getString("ExtTelRefCom2"));
				conocimiento.setTipoRelacion1(resultSet.getString("TipoRelacion1"));
				conocimiento.setTipoRelacion2(resultSet.getString("TipoRelacion2"));
				conocimiento.setPreguntaCte1(resultSet.getString("PreguntaCte1"));
				conocimiento.setRespuestaCte1(resultSet.getString("RespuestaCte1"));

				conocimiento.setPreguntaCte2(resultSet.getString("PreguntaCte2"));
				conocimiento.setRespuestaCte2(resultSet.getString("RespuestaCte2"));
				conocimiento.setPreguntaCte3(resultSet.getString("PreguntaCte3"));
				conocimiento.setRespuestaCte3(resultSet.getString("RespuestaCte3"));
				conocimiento.setPreguntaCte4(resultSet.getString("PreguntaCte4"));

				conocimiento.setRespuestaCte4(resultSet.getString("RespuestaCte4"));
				conocimiento.setCapitalContable(resultSet.getString("CapitalContable"));
				conocimiento.setNivelRiesgo(resultSet.getString("NivelRiesgo"));
				conocimiento.setEvaluaXMatriz(resultSet.getString("EvaluaXMatriz"));
				conocimiento.setComentarioNivel(resultSet.getString("ComentarioNivel"));

				conocimiento.setNoCuentaRefCom(resultSet.getString("NoCuentaRefCom"));
				conocimiento.setNoCuentaRefCom2(resultSet.getString("NoCuentaRefCom2"));
				conocimiento.setDireccionRefCom(resultSet.getString("DireccionRefCom"));
				conocimiento.setDireccionRefCom2(resultSet.getString("DireccionRefCom2"));
				conocimiento.setBanTipoCuentaRef(resultSet.getString("BanTipoCuentaRef"));

				conocimiento.setBanTipoCuentaRef2(resultSet.getString("BanTipoCuentaRef2"));
				conocimiento.setBanSucursalRef(resultSet.getString("BanSucursalRef"));
				conocimiento.setBanSucursalRef2(resultSet.getString("BanSucursalRef2"));
				conocimiento.setBanNoTarjetaRef(resultSet.getString("BanNoTarjetaRef"));
				conocimiento.setBanNoTarjetaRef2(resultSet.getString("BanNoTarjetaRef2"));

				conocimiento.setBanTarjetaInsRef(resultSet.getString("BanTarjetaInsRef"));
				conocimiento.setBanTarjetaInsRef2(resultSet.getString("BanTarjetaInsRef2"));
				conocimiento.setBanCredOtraEnt(resultSet.getString("BanCredOtraEnt"));
				conocimiento.setBanCredOtraEnt2(resultSet.getString("BanCredOtraEnt2"));
				conocimiento.setBanInsOtraEnt(resultSet.getString("BanInsOtraEnt"));

				conocimiento.setBanInsOtraEnt2(resultSet.getString("BanInsOtraEnt2"));
				conocimiento.setOperacionAnios(resultSet.getString("OperacionAnios"));
				conocimiento.setGiroAnios(resultSet.getString("GiroAnios"));
				conocimiento.setFechaNombramiento(resultSet.getString("FechaNombramiento"));
				conocimiento.setPeriodoCargo(resultSet.getString("PeriodoCargo"));

				conocimiento.setPorcentajeAcciones(resultSet.getString("PorcentajeAcciones"));
				conocimiento.setMontoAcciones(resultSet.getString("MontoAcciones"));
				conocimiento.setTiposClientes(resultSet.getString("TiposClientes"));
				conocimiento.setInstrumentosMonetarios(resultSet.getString("InstrumentosMonetarios"));


				return conocimiento;
			}
		});

		return matches.size() > 0 ? (ConocimientoCteBean) matches.get(0) : null;

	}

	/* Consuta Conocimiento del cliente por Llave Foranea*/
	public ConocimientoCteBean consultaForanea(ConocimientoCteBean conocimiento, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CONOCIMIENTOCTECON(?,?,?,?,?,?,?,?,?);";

		Object[] parametros = {conocimiento.getClienteID(), tipoConsulta, Constantes.ENTERO_CERO, Constantes.ENTERO_CERO, Constantes.FECHA_VACIA, Constantes.STRING_VACIO, "ConocimientoCteDAO.consultaPais", Constantes.ENTERO_CERO, Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CONOCIMIENTOCTECON(" + Arrays.toString(parametros) + ")");

		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ConocimientoCteBean conocimiento = new ConocimientoCteBean();
				conocimiento.setClienteID(String.valueOf(resultSet.getInt(1)));

				return conocimiento;

			}
		});

		return matches.size() > 0 ? (ConocimientoCteBean) matches.get(0) : null;
	}

	/* Consuta para saber si el cliente ya tiene un conocimiento de cliente*/
	public ConocimientoCteBean consultaExiste(ConocimientoCteBean conocimiento, int tipoConsulta) {
		ConocimientoCteBean conocimientoCteBean = null;
		try {
			//Query con el Store Procedure
			String query = "call CONOCIMIENTOCTECON(?,?,?,?,?,?,?,?,?);";

			Object[] parametros = {conocimiento.getClienteID(), tipoConsulta, Constantes.ENTERO_CERO, Constantes.ENTERO_CERO, Constantes.FECHA_VACIA, Constantes.STRING_VACIO, "ConocimientoCteDAO.consultaPais", Constantes.ENTERO_CERO, Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CONOCIMIENTOCON(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConocimientoCteBean conocimiento = new ConocimientoCteBean();
					conocimiento.setClienteID(String.valueOf(resultSet.getInt(1)));
					return conocimiento;

				}
			});

			conocimientoCteBean = matches.size() > 0 ? (ConocimientoCteBean) matches.get(0) : null;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error al consultar el conocimiento del cliente", e);
		}
		return conocimientoCteBean;
	}

}
