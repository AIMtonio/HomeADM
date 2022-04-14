package pld.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import herramientas.OperacionesFechas;

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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import pld.bean.ConocimientoUsuarioServiciosBean;

public class ConocimientoUsuarioServiciosDAO extends BaseDAO {

	public ConocimientoUsuarioServiciosDAO() {
		super();
	}

    /**
	* Método para el alta de conocimientos de usuario de servicios.
	* @param conocimientoUsuarioBean : Bean con los datos de conocimientos del usuario.
	* @return {@link MensajeTransaccionBean}.
	*/
	public MensajeTransaccionBean altaConocimiento(final ConocimientoUsuarioServiciosBean conocimientoUsuarioBean) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			    mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

                            String query = "call CONOCIMIENTOUSUSERVALT(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,"
																	 + "?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,"
																	 + "?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,"
																	 + "?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,"
																	 + "?,?,?,?,?,	?,?,?,?,	?,?,?,		?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

                            sentenciaStore.setLong("Par_UsuarioServicioID", Utileria.convierteLong(conocimientoUsuarioBean.getUsuarioID()));
                            sentenciaStore.setString("Par_NombreGrupo", conocimientoUsuarioBean.getNombreGrupo());
                            sentenciaStore.setString("Par_RFC", conocimientoUsuarioBean.getRFC());
                            sentenciaStore.setDouble("Par_Participacion", Utileria.convierteDoble(conocimientoUsuarioBean.getParticipacion()));
                            sentenciaStore.setString("Par_Nacionalidad", conocimientoUsuarioBean.getNacionalidad());

                            sentenciaStore.setString("Par_RazonSocial", conocimientoUsuarioBean.getRazonSocial());
                            sentenciaStore.setString("Par_Giro", conocimientoUsuarioBean.getGiro());
                            sentenciaStore.setInt("Par_AniosOperacion", Utileria.convierteEntero(conocimientoUsuarioBean.getAniosOperacion()));
                            sentenciaStore.setInt("Par_AniosGiro", Utileria.convierteEntero(conocimientoUsuarioBean.getAniosGiro()));
                            sentenciaStore.setString("Par_PEPs", conocimientoUsuarioBean.getPEPs());

                            sentenciaStore.setInt("Par_FuncionID", Utileria.convierteEntero(conocimientoUsuarioBean.getFuncionID()));
                            sentenciaStore.setDate("Par_FechaNombramiento", OperacionesFechas.conversionStrDate(conocimientoUsuarioBean.getFechaNombramiento()));
                            sentenciaStore.setDouble("Par_PorcentajeAcciones", Utileria.convierteDoble(conocimientoUsuarioBean.getPorcentajeAcciones()));
                            sentenciaStore.setString("Par_PeriodoCargo", conocimientoUsuarioBean.getPeriodoCargo());
                            sentenciaStore.setDouble("Par_MontoAcciones", Utileria.convierteDoble(conocimientoUsuarioBean.getMontoAcciones()));

                            sentenciaStore.setString("Par_ParentescoPEP", conocimientoUsuarioBean.getParentescoPEP());
                            sentenciaStore.setString("Par_NombreFamiliar", conocimientoUsuarioBean.getNombreFamiliar());
                            sentenciaStore.setString("Par_APaternoFamiliar", conocimientoUsuarioBean.getaPaternoFamiliar());
                            sentenciaStore.setString("Par_AMaternoFamiliar", conocimientoUsuarioBean.getaMaternoFamiliar());
                            sentenciaStore.setInt("Par_NumeroEmpleados", Utileria.convierteEntero(conocimientoUsuarioBean.getNumeroEmpleados()));

                            sentenciaStore.setString("Par_ServiciosProductos", conocimientoUsuarioBean.getServiciosProductos());
                            sentenciaStore.setString("Par_CoberturaGeografica", conocimientoUsuarioBean.getCoberturaGeografica());
                            sentenciaStore.setInt("Par_EstadosPresencia", Utileria.convierteEntero(conocimientoUsuarioBean.getEstadosPresencia()));
                            sentenciaStore.setDouble("Par_ImporteVentas", Utileria.convierteDoble(conocimientoUsuarioBean.getImporteVentas()));
                            sentenciaStore.setDouble("Par_Activos", Utileria.convierteDoble(conocimientoUsuarioBean.getActivos()));

                            sentenciaStore.setDouble("Par_Pasivos", Utileria.convierteDoble(conocimientoUsuarioBean.getPasivos()));
                            sentenciaStore.setDouble("Par_CapitalContable", Utileria.convierteDoble(conocimientoUsuarioBean.getCapitalContable()));
                            sentenciaStore.setDouble("Par_CapitalNeto", Utileria.convierteDoble(conocimientoUsuarioBean.getCapitalNeto()));
                            sentenciaStore.setString("Par_Importa", conocimientoUsuarioBean.getImporta());
                            sentenciaStore.setString("Par_DolaresImporta", conocimientoUsuarioBean.getDolaresImporta());

                            sentenciaStore.setString("Par_PaisesImporta1", conocimientoUsuarioBean.getPaisesImporta1());
                            sentenciaStore.setString("Par_PaisesImporta2", conocimientoUsuarioBean.getPaisesImporta2());
                            sentenciaStore.setString("Par_PaisesImporta3", conocimientoUsuarioBean.getPaisesImporta3());
                            sentenciaStore.setString("Par_Exporta", conocimientoUsuarioBean.getExporta());
                            sentenciaStore.setString("Par_DolaresExporta", conocimientoUsuarioBean.getDolaresExporta());

                            sentenciaStore.setString("Par_PaisesExporta1", conocimientoUsuarioBean.getPaisesExporta1());
                            sentenciaStore.setString("Par_PaisesExporta2", conocimientoUsuarioBean.getPaisesExporta2());
                            sentenciaStore.setString("Par_PaisesExporta3", conocimientoUsuarioBean.getPaisesExporta3());
                            sentenciaStore.setString("Par_TiposClientes", conocimientoUsuarioBean.getTiposClientes());
                            sentenciaStore.setString("Par_InstrMonetarios", conocimientoUsuarioBean.getInstrMonetarios());

                            sentenciaStore.setString("Par_NombreRefCom1", conocimientoUsuarioBean.getNombreRefCom1());
                            sentenciaStore.setString("Par_NoCuentaRefCom1", conocimientoUsuarioBean.getNoCuentaRefCom1());
                            sentenciaStore.setString("Par_DireccionRefCom1", conocimientoUsuarioBean.getDireccionRefCom1());
                            sentenciaStore.setString("Par_TelefonoRefCom1", conocimientoUsuarioBean.getTelefonoRefCom1());
                            sentenciaStore.setString("Par_ExtTelefonoRefCom1", conocimientoUsuarioBean.getExtTelefonoRefCom1());

                            sentenciaStore.setString("Par_NombreRefCom2", conocimientoUsuarioBean.getNombreRefCom2());
                            sentenciaStore.setString("Par_NoCuentaRefCom2", conocimientoUsuarioBean.getNoCuentaRefCom2());
                            sentenciaStore.setString("Par_DireccionRefCom2", conocimientoUsuarioBean.getDireccionRefCom2());
                            sentenciaStore.setString("Par_TelefonoRefCom2", conocimientoUsuarioBean.getTelefonoRefCom2());
                            sentenciaStore.setString("Par_ExtTelefonoRefCom2", conocimientoUsuarioBean.getExtTelefonoRefCom2());

                            sentenciaStore.setString("Par_BancoRefBanc1", conocimientoUsuarioBean.getBancoRefBanc1());
                            sentenciaStore.setString("Par_TipoCuentaRefBanc1", conocimientoUsuarioBean.getTipoCuentaRefBanc1());
                            sentenciaStore.setString("Par_NoCuentaRefBanc1", conocimientoUsuarioBean.getNoCuentaRefBanc1());
                            sentenciaStore.setString("Par_SucursalRefBanc1", conocimientoUsuarioBean.getSucursalRefBanc1());
                            sentenciaStore.setString("Par_NoTarjetaRefBanc1", conocimientoUsuarioBean.getNoTarjetaRefBanc1());

                            sentenciaStore.setString("Par_InstitucionRefBanc1", conocimientoUsuarioBean.getInstitucionRefBanc1());
                            sentenciaStore.setString("Par_CredOtraEntRefBanc1", conocimientoUsuarioBean.getCredOtraEntRefBanc1());
                            sentenciaStore.setString("Par_InstitucionEntRefBanc1", conocimientoUsuarioBean.getInstitucionEntRefBanc1());
                            sentenciaStore.setString("Par_BancoRefBanc2", conocimientoUsuarioBean.getBancoRefBanc2());
                            sentenciaStore.setString("Par_TipoCuentaRefBanc2", conocimientoUsuarioBean.getTipoCuentaRefBanc2());

                            sentenciaStore.setString("Par_NoCuentaRefBanc2", conocimientoUsuarioBean.getNoCuentaRefBanc2());
                            sentenciaStore.setString("Par_SucursalRefBanc2", conocimientoUsuarioBean.getSucursalRefBanc2());
                            sentenciaStore.setString("Par_NoTarjetaRefBanc2", conocimientoUsuarioBean.getNoTarjetaRefBanc2());
                            sentenciaStore.setString("Par_InstitucionRefBanc2", conocimientoUsuarioBean.getInstitucionRefBanc2());
                            sentenciaStore.setString("Par_CredOtraEntRefBanc2", conocimientoUsuarioBean.getCredOtraEntRefBanc2());

                            sentenciaStore.setString("Par_InstitucionEntRefBanc2", conocimientoUsuarioBean.getInstitucionEntRefBanc2());
                            sentenciaStore.setString("Par_NombreRefPers1", conocimientoUsuarioBean.getNombreRefPers1());
                            sentenciaStore.setString("Par_DomicilioRefPers1", conocimientoUsuarioBean.getDomicilioRefPers1());
                            sentenciaStore.setString("Par_TelefonoRefPers1", conocimientoUsuarioBean.getTelefonoRefPers1());
                            sentenciaStore.setString("Par_ExtTelefonoRefPers1", conocimientoUsuarioBean.getExtTelefonoRefPers1());

                            sentenciaStore.setInt("Par_TipoRelacionRefPers1", Utileria.convierteEntero(conocimientoUsuarioBean.getTipoRelacionRefPers1()));
                            sentenciaStore.setString("Par_NombreRefPers2", conocimientoUsuarioBean.getNombreRefPers2());
                            sentenciaStore.setString("Par_DomicilioRefPers2", conocimientoUsuarioBean.getDomicilioRefPers2());
                            sentenciaStore.setString("Par_TelefonoRefPers2", conocimientoUsuarioBean.getTelefonoRefPers2());
                            sentenciaStore.setString("Par_ExtTelefonoRefPers2", conocimientoUsuarioBean.getExtTelefonoRefPers2());

                            sentenciaStore.setInt("Par_TipoRelacionRefPers2", Utileria.convierteEntero(conocimientoUsuarioBean.getTipoRelacionRefPers2()));
                            sentenciaStore.setString("Par_PreguntaUsuario1", conocimientoUsuarioBean.getPreguntaUsuario1());
                            sentenciaStore.setString("Par_RespuestaUsuario1", conocimientoUsuarioBean.getRespuestaUsuario1());
                            sentenciaStore.setString("Par_PreguntaUsuario2", conocimientoUsuarioBean.getPreguntaUsuario2());
                            sentenciaStore.setString("Par_RespuestaUsuario2", conocimientoUsuarioBean.getRespuestaUsuario2());

                            sentenciaStore.setString("Par_PreguntaUsuario3", conocimientoUsuarioBean.getPreguntaUsuario3());
                            sentenciaStore.setString("Par_RespuestaUsuario3", conocimientoUsuarioBean.getRespuestaUsuario3());
                            sentenciaStore.setString("Par_PreguntaUsuario4", conocimientoUsuarioBean.getPreguntaUsuario4());
                            sentenciaStore.setString("Par_RespuestaUsuario4", conocimientoUsuarioBean.getRespuestaUsuario4());
                            sentenciaStore.setString("Par_PrincipalFuenteIng", conocimientoUsuarioBean.getPrincipalFuenteIng());

                            sentenciaStore.setString("Par_IngAproxPorMes", conocimientoUsuarioBean.getIngAproxPorMes());
                            sentenciaStore.setString("Par_NivelRiesgo", conocimientoUsuarioBean.getNivelRiesgo());
                            sentenciaStore.setString("Par_EvaluaXMatriz", conocimientoUsuarioBean.getEvaluaXMatriz());
                            sentenciaStore.setString("Par_ComentarioNivel", conocimientoUsuarioBean.getComentarioNivel());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.CHAR);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

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
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
                                mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if (mensajeBean ==  null) {
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de conocimientos del usuario de servicios: ", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

    /**
	* Método para la modificación de conocimientos de usuario de servicios.
	* @param conocimientoUsuarioBean : Bean con los datos de conocimientos del usuario.
	* @return {@link MensajeTransaccionBean}.
	*/
	public MensajeTransaccionBean modificacionConocimiento(final ConocimientoUsuarioServiciosBean conocimientoUsuarioBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		    public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			        mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

                            String query = "call CONOCIMIENTOUSUSERVMOD(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,"
																	 + "?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,"
																	 + "?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,"
																	 + "?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,"
																	 + "?,?,?,?,?,	?,?,?,?,	?,?,?,		?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

                            sentenciaStore.setLong("Par_UsuarioServicioID", Utileria.convierteLong(conocimientoUsuarioBean.getUsuarioID()));
                            sentenciaStore.setString("Par_NombreGrupo", conocimientoUsuarioBean.getNombreGrupo());
                            sentenciaStore.setString("Par_RFC", conocimientoUsuarioBean.getRFC());
                            sentenciaStore.setDouble("Par_Participacion", Utileria.convierteDoble(conocimientoUsuarioBean.getParticipacion()));
                            sentenciaStore.setString("Par_Nacionalidad", conocimientoUsuarioBean.getNacionalidad());

                            sentenciaStore.setString("Par_RazonSocial", conocimientoUsuarioBean.getRazonSocial());
                            sentenciaStore.setString("Par_Giro", conocimientoUsuarioBean.getGiro());
                            sentenciaStore.setInt("Par_AniosOperacion", Utileria.convierteEntero(conocimientoUsuarioBean.getAniosOperacion()));
                            sentenciaStore.setInt("Par_AniosGiro", Utileria.convierteEntero(conocimientoUsuarioBean.getAniosGiro()));
                            sentenciaStore.setString("Par_PEPs", conocimientoUsuarioBean.getPEPs());

                            sentenciaStore.setInt("Par_FuncionID", Utileria.convierteEntero(conocimientoUsuarioBean.getFuncionID()));
                            sentenciaStore.setDate("Par_FechaNombramiento", OperacionesFechas.conversionStrDate(conocimientoUsuarioBean.getFechaNombramiento()));
                            sentenciaStore.setDouble("Par_PorcentajeAcciones", Utileria.convierteDoble(conocimientoUsuarioBean.getPorcentajeAcciones()));
                            sentenciaStore.setString("Par_PeriodoCargo", conocimientoUsuarioBean.getPeriodoCargo());
                            sentenciaStore.setDouble("Par_MontoAcciones", Utileria.convierteDoble(conocimientoUsuarioBean.getMontoAcciones()));

                            sentenciaStore.setString("Par_ParentescoPEP", conocimientoUsuarioBean.getParentescoPEP());
                            sentenciaStore.setString("Par_NombreFamiliar", conocimientoUsuarioBean.getNombreFamiliar());
                            sentenciaStore.setString("Par_APaternoFamiliar", conocimientoUsuarioBean.getaPaternoFamiliar());
                            sentenciaStore.setString("Par_AMaternoFamiliar", conocimientoUsuarioBean.getaMaternoFamiliar());
                            sentenciaStore.setInt("Par_NumeroEmpleados", Utileria.convierteEntero(conocimientoUsuarioBean.getNumeroEmpleados()));

                            sentenciaStore.setString("Par_ServiciosProductos", conocimientoUsuarioBean.getServiciosProductos());
                            sentenciaStore.setString("Par_CoberturaGeografica", conocimientoUsuarioBean.getCoberturaGeografica());
                            sentenciaStore.setInt("Par_EstadosPresencia", Utileria.convierteEntero(conocimientoUsuarioBean.getEstadosPresencia()));
                            sentenciaStore.setDouble("Par_ImporteVentas", Utileria.convierteDoble(conocimientoUsuarioBean.getImporteVentas()));
                            sentenciaStore.setDouble("Par_Activos", Utileria.convierteDoble(conocimientoUsuarioBean.getActivos()));

                            sentenciaStore.setDouble("Par_Pasivos", Utileria.convierteDoble(conocimientoUsuarioBean.getPasivos()));
                            sentenciaStore.setDouble("Par_CapitalContable", Utileria.convierteDoble(conocimientoUsuarioBean.getCapitalContable()));
                            sentenciaStore.setDouble("Par_CapitalNeto", Utileria.convierteDoble(conocimientoUsuarioBean.getCapitalNeto()));
                            sentenciaStore.setString("Par_Importa", conocimientoUsuarioBean.getImporta());
                            sentenciaStore.setString("Par_DolaresImporta", conocimientoUsuarioBean.getDolaresImporta());

                            sentenciaStore.setString("Par_PaisesImporta1", conocimientoUsuarioBean.getPaisesImporta1());
                            sentenciaStore.setString("Par_PaisesImporta2", conocimientoUsuarioBean.getPaisesImporta2());
                            sentenciaStore.setString("Par_PaisesImporta3", conocimientoUsuarioBean.getPaisesImporta3());
                            sentenciaStore.setString("Par_Exporta", conocimientoUsuarioBean.getExporta());
                            sentenciaStore.setString("Par_DolaresExporta", conocimientoUsuarioBean.getDolaresExporta());

                            sentenciaStore.setString("Par_PaisesExporta1", conocimientoUsuarioBean.getPaisesExporta1());
                            sentenciaStore.setString("Par_PaisesExporta2", conocimientoUsuarioBean.getPaisesExporta2());
                            sentenciaStore.setString("Par_PaisesExporta3", conocimientoUsuarioBean.getPaisesExporta3());
                            sentenciaStore.setString("Par_TiposClientes", conocimientoUsuarioBean.getTiposClientes());
                            sentenciaStore.setString("Par_InstrMonetarios", conocimientoUsuarioBean.getInstrMonetarios());

                            sentenciaStore.setString("Par_NombreRefCom1", conocimientoUsuarioBean.getNombreRefCom1());
                            sentenciaStore.setString("Par_NoCuentaRefCom1", conocimientoUsuarioBean.getNoCuentaRefCom1());
                            sentenciaStore.setString("Par_DireccionRefCom1", conocimientoUsuarioBean.getDireccionRefCom1());
                            sentenciaStore.setString("Par_TelefonoRefCom1", conocimientoUsuarioBean.getTelefonoRefCom1());
                            sentenciaStore.setString("Par_ExtTelefonoRefCom1", conocimientoUsuarioBean.getExtTelefonoRefCom1());

                            sentenciaStore.setString("Par_NombreRefCom2", conocimientoUsuarioBean.getNombreRefCom2());
                            sentenciaStore.setString("Par_NoCuentaRefCom2", conocimientoUsuarioBean.getNoCuentaRefCom2());
                            sentenciaStore.setString("Par_DireccionRefCom2", conocimientoUsuarioBean.getDireccionRefCom2());
                            sentenciaStore.setString("Par_TelefonoRefCom2", conocimientoUsuarioBean.getTelefonoRefCom2());
                            sentenciaStore.setString("Par_ExtTelefonoRefCom2", conocimientoUsuarioBean.getExtTelefonoRefCom2());

                            sentenciaStore.setString("Par_BancoRefBanc1", conocimientoUsuarioBean.getBancoRefBanc1());
                            sentenciaStore.setString("Par_TipoCuentaRefBanc1", conocimientoUsuarioBean.getTipoCuentaRefBanc1());
                            sentenciaStore.setString("Par_NoCuentaRefBanc1", conocimientoUsuarioBean.getNoCuentaRefBanc1());
                            sentenciaStore.setString("Par_SucursalRefBanc1", conocimientoUsuarioBean.getSucursalRefBanc1());
                            sentenciaStore.setString("Par_NoTarjetaRefBanc1", conocimientoUsuarioBean.getNoTarjetaRefBanc1());

                            sentenciaStore.setString("Par_InstitucionRefBanc1", conocimientoUsuarioBean.getInstitucionRefBanc1());
                            sentenciaStore.setString("Par_CredOtraEntRefBanc1", conocimientoUsuarioBean.getCredOtraEntRefBanc1());
                            sentenciaStore.setString("Par_InstitucionEntRefBanc1", conocimientoUsuarioBean.getInstitucionEntRefBanc1());
                            sentenciaStore.setString("Par_BancoRefBanc2", conocimientoUsuarioBean.getBancoRefBanc2());
                            sentenciaStore.setString("Par_TipoCuentaRefBanc2", conocimientoUsuarioBean.getTipoCuentaRefBanc2());

                            sentenciaStore.setString("Par_NoCuentaRefBanc2", conocimientoUsuarioBean.getNoCuentaRefBanc2());
                            sentenciaStore.setString("Par_SucursalRefBanc2", conocimientoUsuarioBean.getSucursalRefBanc2());
                            sentenciaStore.setString("Par_NoTarjetaRefBanc2", conocimientoUsuarioBean.getNoTarjetaRefBanc2());
                            sentenciaStore.setString("Par_InstitucionRefBanc2", conocimientoUsuarioBean.getInstitucionRefBanc2());
                            sentenciaStore.setString("Par_CredOtraEntRefBanc2", conocimientoUsuarioBean.getCredOtraEntRefBanc2());

                            sentenciaStore.setString("Par_InstitucionEntRefBanc2", conocimientoUsuarioBean.getInstitucionEntRefBanc2());
                            sentenciaStore.setString("Par_NombreRefPers1", conocimientoUsuarioBean.getNombreRefPers1());
                            sentenciaStore.setString("Par_DomicilioRefPers1", conocimientoUsuarioBean.getDomicilioRefPers1());
                            sentenciaStore.setString("Par_TelefonoRefPers1", conocimientoUsuarioBean.getTelefonoRefPers1());
                            sentenciaStore.setString("Par_ExtTelefonoRefPers1", conocimientoUsuarioBean.getExtTelefonoRefPers1());

                            sentenciaStore.setInt("Par_TipoRelacionRefPers1", Utileria.convierteEntero(conocimientoUsuarioBean.getTipoRelacionRefPers1()));
                            sentenciaStore.setString("Par_NombreRefPers2", conocimientoUsuarioBean.getNombreRefPers2());
                            sentenciaStore.setString("Par_DomicilioRefPers2", conocimientoUsuarioBean.getDomicilioRefPers2());
                            sentenciaStore.setString("Par_TelefonoRefPers2", conocimientoUsuarioBean.getTelefonoRefPers2());
                            sentenciaStore.setString("Par_ExtTelefonoRefPers2", conocimientoUsuarioBean.getExtTelefonoRefPers2());

                            sentenciaStore.setInt("Par_TipoRelacionRefPers2", Utileria.convierteEntero(conocimientoUsuarioBean.getTipoRelacionRefPers2()));
                            sentenciaStore.setString("Par_PreguntaUsuario1", conocimientoUsuarioBean.getPreguntaUsuario1());
                            sentenciaStore.setString("Par_RespuestaUsuario1", conocimientoUsuarioBean.getRespuestaUsuario1());
                            sentenciaStore.setString("Par_PreguntaUsuario2", conocimientoUsuarioBean.getPreguntaUsuario2());
                            sentenciaStore.setString("Par_RespuestaUsuario2", conocimientoUsuarioBean.getRespuestaUsuario2());

                            sentenciaStore.setString("Par_PreguntaUsuario3", conocimientoUsuarioBean.getPreguntaUsuario3());
                            sentenciaStore.setString("Par_RespuestaUsuario3", conocimientoUsuarioBean.getRespuestaUsuario3());
                            sentenciaStore.setString("Par_PreguntaUsuario4", conocimientoUsuarioBean.getPreguntaUsuario4());
                            sentenciaStore.setString("Par_RespuestaUsuario4", conocimientoUsuarioBean.getRespuestaUsuario4());
                            sentenciaStore.setString("Par_PrincipalFuenteIng", conocimientoUsuarioBean.getPrincipalFuenteIng());

                            sentenciaStore.setString("Par_IngAproxPorMes", conocimientoUsuarioBean.getIngAproxPorMes());
                            sentenciaStore.setString("Par_NivelRiesgo", conocimientoUsuarioBean.getNivelRiesgo());
                            sentenciaStore.setString("Par_EvaluaXMatriz", conocimientoUsuarioBean.getEvaluaXMatriz());
                            sentenciaStore.setString("Par_ComentarioNivel", conocimientoUsuarioBean.getComentarioNivel());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.CHAR);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {

                            MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();
								
								resultadosStore.next();
								mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
                                mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}

							return mensajeTransaccion;
						}
					});

                    if (mensajeBean ==  null){
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la modificacion de conocimientos del usuario de servicios: ", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

    /**
	* Método para consultar los conocimientos del usuario de servicios.
	* @param tipoConsulta : Número de consulta 1. Consulta principal para conocimiento de usuario.
	* @param conocimientoUsuarioBean : Bean con los datos necesarios del usuario de servicios a consultar.
	* @return {@link ConocimientoUsuarioServiciosBean}.
	*/
	public ConocimientoUsuarioServiciosBean consultaPrincipal(int tipoConsulta, ConocimientoUsuarioServiciosBean conocimientoUsuarioBean) {

        ConocimientoUsuarioServiciosBean conocimientoUsuarioServiciosBean = new ConocimientoUsuarioServiciosBean();

		try{
			String query = "call CONOCIMIENTOUSUSERVCON(?,?,  ?,?,?,?,?,?,?);";

			Object[] parametros = {
				Utileria.convierteEntero(conocimientoUsuarioBean.getUsuarioID()),
				tipoConsulta,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"ConocimientoUsuarioServiciosDAO.consultaPrincipal",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONOCIMIENTOUSUSERVCON(" + Arrays.toString(parametros) +")");

            List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					ConocimientoUsuarioServiciosBean conocimiento = new ConocimientoUsuarioServiciosBean();

					conocimiento.setUsuarioID(resultSet.getString("UsuarioServicioID"));
                    conocimiento.setNombreGrupo(resultSet.getString("NombreGrupo"));
                    conocimiento.setRFC(resultSet.getString("RFC"));
                    conocimiento.setParticipacion(resultSet.getString("Participacion"));
                    conocimiento.setNacionalidad(resultSet.getString("Nacionalidad"));

					conocimiento.setRazonSocial(resultSet.getString("RazonSocial"));
                    conocimiento.setGiro(resultSet.getString("Giro"));
                    conocimiento.setAniosOperacion(resultSet.getString("AniosOperacion"));
                    conocimiento.setAniosGiro(resultSet.getString("AniosGiro"));
                    conocimiento.setPEPs(resultSet.getString("PEPs"));

					conocimiento.setFuncionID(resultSet.getString("FuncionID"));
                    conocimiento.setFuncionDescripcion(resultSet.getString("FuncDesc"));
                    conocimiento.setFechaNombramiento(resultSet.getString("FechaNombramiento"));
                    conocimiento.setPorcentajeAcciones(resultSet.getString("PorcentajeAcciones"));
                    conocimiento.setPeriodoCargo(resultSet.getString("PeriodoCargo"));

					conocimiento.setMontoAcciones(resultSet.getString("MontoAcciones"));
                    conocimiento.setParentescoPEP(resultSet.getString("ParentescoPEP"));
                    conocimiento.setNombreFamiliar(resultSet.getString("NombreFamiliar"));
                    conocimiento.setaPaternoFamiliar(resultSet.getString("aPaternoFamiliar"));
                    conocimiento.setaMaternoFamiliar(resultSet.getString("aMaternoFamiliar"));

					conocimiento.setNumeroEmpleados(resultSet.getString("NumeroEmpleados"));
                    conocimiento.setServiciosProductos(resultSet.getString("ServiciosProductos"));
                    conocimiento.setCoberturaGeografica(resultSet.getString("CoberturaGeografica"));
                    conocimiento.setEstadosPresencia(resultSet.getString("EstadosPresencia"));
                    conocimiento.setImporteVentas(resultSet.getString("ImporteVentas"));

					conocimiento.setActivos(resultSet.getString("Activos"));
                    conocimiento.setPasivos(resultSet.getString("Pasivos"));
                    conocimiento.setCapitalContable(resultSet.getString("CapitalContable"));
                    conocimiento.setCapitalNeto(resultSet.getString("CapitalNeto"));
                    conocimiento.setImporta(resultSet.getString("Importa"));

					conocimiento.setDolaresImporta(resultSet.getString("DolaresImporta"));
                    conocimiento.setPaisesImporta1(resultSet.getString("PaisesImporta1"));
                    conocimiento.setPaisesImporta2(resultSet.getString("PaisesImporta2"));
                    conocimiento.setPaisesImporta3(resultSet.getString("PaisesImporta3"));
                    conocimiento.setExporta(resultSet.getString("Exporta"));

					conocimiento.setDolaresExporta(resultSet.getString("DolaresExporta"));
                    conocimiento.setPaisesExporta1(resultSet.getString("PaisesExporta1"));
                    conocimiento.setPaisesExporta2(resultSet.getString("PaisesExporta2"));
                    conocimiento.setPaisesExporta3(resultSet.getString("PaisesExporta3"));
                    conocimiento.setTiposClientes(resultSet.getString("TiposClientes"));

					conocimiento.setInstrMonetarios(resultSet.getString("InstrMonetarios"));
                    conocimiento.setNombreRefCom1(resultSet.getString("NombreRefCom1"));
                    conocimiento.setNoCuentaRefCom1(resultSet.getString("NoCuentaRefCom1"));
                    conocimiento.setDireccionRefCom1(resultSet.getString("DireccionRefCom1"));
                    conocimiento.setTelefonoRefCom1(resultSet.getString("TelefonoRefCom1"));

					conocimiento.setExtTelefonoRefCom1(resultSet.getString("ExtTelefonoRefCom1"));
                    conocimiento.setNombreRefCom2(resultSet.getString("NombreRefCom2"));
                    conocimiento.setNoCuentaRefCom2(resultSet.getString("NoCuentaRefCom2"));
                    conocimiento.setDireccionRefCom2(resultSet.getString("DireccionRefCom2"));
                    conocimiento.setTelefonoRefCom2(resultSet.getString("TelefonoRefCom2"));

					conocimiento.setExtTelefonoRefCom2(resultSet.getString("ExtTelefonoRefCom2"));
                    conocimiento.setBancoRefBanc1(resultSet.getString("BancoRefBanc1"));
                    conocimiento.setTipoCuentaRefBanc1(resultSet.getString("TipoCuentaRefBanc1"));
                    conocimiento.setNoCuentaRefBanc1(resultSet.getString("NoCuentaRefBanc1"));
                    conocimiento.setSucursalRefBanc1(resultSet.getString("SucursalRefBanc1"));

					conocimiento.setNoTarjetaRefBanc1(resultSet.getString("NoTarjetaRefBanc1"));
                    conocimiento.setInstitucionRefBanc1(resultSet.getString("InstitucionRefBanc1"));
                    conocimiento.setCredOtraEntRefBanc1(resultSet.getString("CredOtraEntRefBanc1"));
                    conocimiento.setInstitucionEntRefBanc1(resultSet.getString("InstitucionEntRefBanc1"));
                    conocimiento.setBancoRefBanc2(resultSet.getString("BancoRefBanc2"));

					conocimiento.setTipoCuentaRefBanc2(resultSet.getString("TipoCuentaRefBanc2"));
                    conocimiento.setNoCuentaRefBanc2(resultSet.getString("NoCuentaRefBanc2"));
                    conocimiento.setSucursalRefBanc2(resultSet.getString("SucursalRefBanc2"));
                    conocimiento.setNoTarjetaRefBanc2(resultSet.getString("NoTarjetaRefBanc2"));
                    conocimiento.setInstitucionRefBanc2(resultSet.getString("InstitucionRefBanc2"));

					conocimiento.setCredOtraEntRefBanc2(resultSet.getString("CredOtraEntRefBanc2"));
                    conocimiento.setInstitucionEntRefBanc2(resultSet.getString("InstitucionEntRefBanc2"));
                    conocimiento.setNombreRefPers1(resultSet.getString("NombreRefPers1"));
                    conocimiento.setDomicilioRefPers1(resultSet.getString("DomicilioRefPers1"));
                    conocimiento.setTelefonoRefPers1(resultSet.getString("TelefonoRefPers1"));

					conocimiento.setExtTelefonoRefPers1(resultSet.getString("ExtTelefonoRefPers1"));
                    conocimiento.setTipoRelacionRefPers1(resultSet.getString("TipoRelacionRefPers1"));
                    conocimiento.setTipoRelacion1Desc(resultSet.getString("RelacDesc1"));
                    conocimiento.setNombreRefPers2(resultSet.getString("NombreRefPers2"));
                    conocimiento.setDomicilioRefPers2(resultSet.getString("DomicilioRefPers2"));

					conocimiento.setTelefonoRefPers2(resultSet.getString("TelefonoRefPers2"));
                    conocimiento.setExtTelefonoRefPers2(resultSet.getString("ExtTelefonoRefPers2"));
                    conocimiento.setTipoRelacionRefPers2(resultSet.getString("TipoRelacionRefPers2"));
                    conocimiento.setTipoRelacion2Desc(resultSet.getString("RelacDesc2"));
                    conocimiento.setPreguntaUsuario1(resultSet.getString("PreguntaUsuario1"));

					conocimiento.setRespuestaUsuario1(resultSet.getString("RespuestaUsuario1"));
                    conocimiento.setPreguntaUsuario2(resultSet.getString("PreguntaUsuario2"));
                    conocimiento.setRespuestaUsuario2(resultSet.getString("RespuestaUsuario2"));
                    conocimiento.setPreguntaUsuario3(resultSet.getString("PreguntaUsuario3"));
                    conocimiento.setRespuestaUsuario3(resultSet.getString("RespuestaUsuario3"));

					conocimiento.setPreguntaUsuario4(resultSet.getString("PreguntaUsuario4"));
                    conocimiento.setRespuestaUsuario4(resultSet.getString("RespuestaUsuario4"));
                    conocimiento.setPrincipalFuenteIng(resultSet.getString("PrincipalFuenteIng"));
                    conocimiento.setIngAproxPorMes(resultSet.getString("IngAproxPorMes"));
					conocimiento.setEvaluaXMatriz(resultSet.getString("EvaluaXMatriz"));

					conocimiento.setComentarioNivel(resultSet.getString("ComentarioNivel"));

					return conocimiento;
				}
			});

            if (matches.size() > 0) {
                conocimientoUsuarioServiciosBean  = (ConocimientoUsuarioServiciosBean) matches.get(0);
            }
		} catch(Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la consulta de conocimientos de usuario de servicios: ", e);
            conocimientoUsuarioServiciosBean = null;
		}

		return conocimientoUsuarioServiciosBean;
	}
}
