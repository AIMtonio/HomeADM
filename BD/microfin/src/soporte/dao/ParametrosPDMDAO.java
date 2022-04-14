package soporte.dao;

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

import soporte.bean.ParametrosPDMBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ParametrosPDMDAO extends BaseDAO{

	public ParametrosPDMDAO() {
		super();
		// TODO Auto-generated constructor stub
	}

	// Modifica Parametros Pademobile
	public MensajeTransaccionBean modificaPametrosPDM(final ParametrosPDMBean parametrosPDMBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PARAMETROSPDMMOD(?,?,?,?,?, ?,?,?,?,?,	?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_EmpresaID",Utileria.convierteEntero(parametrosPDMBean.getEmpresaID()));
								sentenciaStore.setString("Par_NombreServicio",parametrosPDMBean.getNombreServicio());
								sentenciaStore.setInt("Par_NumeroPreguntas",Utileria.convierteEntero(parametrosPDMBean.getNumeroPreguntas()));
								sentenciaStore.setInt("Par_NumeroRespuestas",Utileria.convierteEntero(parametrosPDMBean.getNumeroRespuestas()));


								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Modificación Parámetros PADEMOBILE", e);
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

	public ParametrosPDMBean consultaPrincipal(ParametrosPDMBean parametrosPDMBean, int tipoConsulta) {
		//Query con el Store Procedure
		ParametrosPDMBean parametrosPDMBeanCon = null;
		String query = "call PARAMETROSPDMCON(?,?, ?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteEntero(parametrosPDMBean.getEmpresaID()),
								tipoConsulta,

								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"ParametrosPDMDAO.consultaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSPDMCON(" + Arrays.toString(parametros) +")");

		try{
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParametrosPDMBean parametrosPDMBean = new ParametrosPDMBean();

					parametrosPDMBean.setEmpresaID(resultSet.getString("EmpresaID"));
					parametrosPDMBean.setTimeOut(Utileria.convierteEntero(resultSet.getString("TimeOut")));
					parametrosPDMBean.setUrlWSDLLogin(resultSet.getString("UrlWSDLLogin"));
					parametrosPDMBean.setUrlWSDLLogout(resultSet.getString("UrlWSDLLogout"));
					parametrosPDMBean.setUrlWSDLAlta(resultSet.getString("UrlWSDLAlta"));
					parametrosPDMBean.setUrlWSDLBloqueo(resultSet.getString("UrlWSDLBloqueo"));
					parametrosPDMBean.setUrlWSDLDesBloqueo(resultSet.getString("UrlWSDLDesBloqueo"));
					parametrosPDMBean.setNombreServicio(resultSet.getString("NombreServicio"));
					parametrosPDMBean.setNumeroPreguntas(resultSet.getString("NumeroPreguntas"));
					parametrosPDMBean.setNumeroRespuestas(resultSet.getString("NumeroRespuestas"));

					return parametrosPDMBean;
				}
			});

			parametrosPDMBeanCon = matches.size() > 0 ? (ParametrosPDMBean) matches.get(0) : null;


		}catch (Exception e) {
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Consultar Los Parametros PADEMOBILE", e);
		}


		return parametrosPDMBeanCon;

	}
}
