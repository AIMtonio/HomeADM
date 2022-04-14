package nomina.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import nomina.bean.ParametrosNominaBean;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ParametrosNominaDAO extends BaseDAO {


	/*Modificacion de Parametros*/
	public MensajeTransaccionBean modificaParams(final ParametrosNominaBean parametrosNominaBean) {
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
										String query = "call PARAMETROSNOMINAMOD(?,?,?,?,?,  ?,?,?, ?,?,?, ?,?,?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setInt("Par_EmpresaID",Utileria.convierteEntero(parametrosNominaBean.getEmpresaID()));
										sentenciaStore.setString("Par_Correo",parametrosNominaBean.getCorreoElectronico());
										sentenciaStore.setString("Par_CtaTransito",parametrosNominaBean.getCtaPagoTransito());
										sentenciaStore.setString("Par_NomenclaturaCR",parametrosNominaBean.getNomenclaturaCR());
										sentenciaStore.setString("Par_TipoMovTeso",parametrosNominaBean.getTipoMovTesoID());

										sentenciaStore.setString("Par_PerfilAutCalend",parametrosNominaBean.getPerfilAutCalend());
										sentenciaStore.setString("Par_CtaTransDomicilia",parametrosNominaBean.getCtaTransDomicilia());
										sentenciaStore.setString("Par_TipoMovDomiciliaID",parametrosNominaBean.getTipoMovDomiciliaID());

										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										//Parametros de Auditoria
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
											mensajeTransaccion.setDescripcion(Constantes.STRING_VACIO);
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
								throw new Exception(Constantes.MSG_ERROR + " .ParametrosNominaDAO.modificaParametros");
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion de Parametros de nomina" + e);
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
	/* Consuta Parametros*/
	public ParametrosNominaBean consultaParametros(ParametrosNominaBean parametrosNominaBean, int tipoConsulta) {
		ParametrosNominaBean parametrosNomina = null;
	try{
		//Query con el Store Procedure
		String query = "call PARAMETROSNOMINACON(?,?,?,?,?,?,?,?);";
		Object[] parametros = {	parametrosNominaBean.getEmpresaID(),
								tipoConsulta,


								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSNOMINACON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ParametrosNominaBean bean = new ParametrosNominaBean();
				bean.setEmpresaID(resultSet.getString("EmpresaID"));
				bean.setCorreoElectronico(resultSet.getString("CorreoElectronico"));
				bean.setCtaPagoTransito(resultSet.getString("CtaPagoTransito"));
				bean.setNomenclaturaCR(resultSet.getString("NomenclaturaCR"));
				bean.setTipoMovTesoID(resultSet.getString("TipoMovTesCon"));
				bean.setPerfilAutCalend(resultSet.getString("PerfilAutCalend"));

				bean.setCtaTransDomicilia(resultSet.getString("CtaTransDomicilia"));
				bean.setTipoMovDomiciliaID(resultSet.getString("TipoMovDomiciliaID"));

				return bean;

					}
		});
		parametrosNomina= matches.size() > 0 ? (ParametrosNominaBean) matches.get(0) : null;
	}catch(Exception e){

		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de clientes", e);

	}
	return parametrosNomina;
	}


}
