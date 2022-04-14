package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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

import credito.bean.ParamsReservCastigBean;
import credito.bean.ProductosCreditoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ParamsReservCastigDAO extends BaseDAO{

	public ParamsReservCastigDAO() {
		super();
		// TODO Auto-generated constructor stub
	}

	/* Modificacion de Parametros */
	public MensajeTransaccionBean modificaParametros(final ParamsReservCastigBean bean) {
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
									String query = "call PARAMSRESERVCASTIGMOD(" +
										"?,?,?,?,?, 	?,?,?,?,?,		?,?,?,?,?,		?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_EmpresaID",Utileria.convierteEntero(bean.getEmpresaID()));
									sentenciaStore.setString("Par_RegContaEPRC",bean.getRegContaEPRC());
									sentenciaStore.setString("Par_EPRCIntMorato",bean.getePRCIntMorato());
									sentenciaStore.setString("Par_DivideEPRCCapitaInteres",bean.getDivideEPRCCapitaInteres());
									sentenciaStore.setString("Par_CondonaIntereCarVen",bean.getCondonaIntereCarVen());

									sentenciaStore.setString("Par_CondonaMoratoCarVen",bean.getCondonaMoratoCarVen());
									sentenciaStore.setString("Par_CondonaAccesorios",bean.getCondonaAccesorios());
									sentenciaStore.setString("Par_EPRCAdicional", bean.getEprcAdicional());
									sentenciaStore.setString("Par_divideCastigo",bean.getDivideCastigo());
									sentenciaStore.setString("Par_IVARecuperacion",bean.getIVARecuperacion());

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ParamsReservCastigDAO.modificaParametros");
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
							throw new Exception(Constantes.MSG_ERROR + " .ParamsReservCastigDAO.modificaParametros");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion de Parametros" + e);
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

	//consulta Parametros
	public ParamsReservCastigBean consultaPrincipal(ParamsReservCastigBean paramsReservCastigBean, int tipoConsulta) {
		ParamsReservCastigBean paramsReservCastig = new ParamsReservCastigBean();
		try{
			//Query con el Store Procedure
			String query = "call PARAMSRESERVCASTIGCON(?,? ,?,?,?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(paramsReservCastigBean.getEmpresaID()),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ParamsReservCastigDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMSRESERVCASTIGCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParamsReservCastigBean bean = new ParamsReservCastigBean();
					bean.setEmpresaID(resultSet.getString("EmpresaID"));
					bean.setRegContaEPRC(resultSet.getString("RegContaEPRC"));
					bean.setePRCIntMorato(resultSet.getString("EPRCIntMorato"));
					bean.setDivideEPRCCapitaInteres(resultSet.getString("DivideEPRCCapitaInteres"));
					bean.setCondonaIntereCarVen(resultSet.getString("CondonaIntereCarVen"));
					bean.setCondonaMoratoCarVen(resultSet.getString("CondonaMoratoCarVen"));
					bean.setCondonaAccesorios(resultSet.getString("CondonaAccesorios"));
					bean.setDivideCastigo(resultSet.getString("DivideCastigo"));
					bean.setEprcAdicional(resultSet.getString("EPRCAdicional"));
					bean.setIVARecuperacion(resultSet.getString("IVARecuperacion"));

					return bean;
				}
			});
			paramsReservCastig =  matches.size() > 0 ? (ParamsReservCastigBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return paramsReservCastig;
	}

}
