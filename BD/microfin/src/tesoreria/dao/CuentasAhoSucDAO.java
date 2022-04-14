package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.SimpleDateFormat;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;


import tesoreria.bean.CuentasAhoSucBean;

public class CuentasAhoSucDAO extends BaseDAO{

	public CuentasAhoSucDAO(){
		super();
	}

final String salidaPantalla="S";

	public MensajeTransaccionBean altaCuentaSuc(final CuentasAhoSucBean cuentasAhoSucBean) {
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
								String query = "call CUENTASAHOSUCURALT(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
							/*1*/	sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(cuentasAhoSucBean.getSucursalID()));
							/*2*/	sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(cuentasAhoSucBean.getInstitucionID()));
							/*3*/	sentenciaStore.setString("Par_CueClave",cuentasAhoSucBean.getCueClave());
							/*4*/	sentenciaStore.setString("Par_EsPrincipal",cuentasAhoSucBean.getEsPrincipal());
							/*5*/	sentenciaStore.setString("Par_Estatus",cuentasAhoSucBean.getEstatus());

							/*6*/	sentenciaStore.setString("Par_Salida",salidaPantalla);
							/*7*/	sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							/*8*/	sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							/*9*/	sentenciaStore.registerOutParameter("Var_FolioSalida", Types.BIGINT);

							/*10*/	sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							/*11*/	sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							/*12*/	sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							/*13*/	sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							/*14*/	sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							/*15*/	sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
					    	/*16*/	sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
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
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cuenta sucursal", e);
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


	public MensajeTransaccionBean modificarCuentaSuc(final CuentasAhoSucBean cuentasAhoSucBean) {
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
								String query = "call CUENTASAHOSUCURMOD(?,?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
						    /*1*/	sentenciaStore.setInt("Par_CuentaSucurID",Utileria.convierteEntero(cuentasAhoSucBean.getCuentaSucurID()));
							/*1*/	sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(cuentasAhoSucBean.getSucursalID()));
							/*2*/	sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(cuentasAhoSucBean.getInstitucionID()));
							/*3*/	sentenciaStore.setString("Par_CueClave",cuentasAhoSucBean.getCueClave());
							/*4*/	sentenciaStore.setString("Par_EsPrincipal",cuentasAhoSucBean.getEsPrincipal());
							/*5*/	sentenciaStore.setString("Par_Estatus",cuentasAhoSucBean.getEstatus());

							/*6*/	sentenciaStore.setString("Par_Salida",salidaPantalla);
							/*7*/	sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							/*8*/	sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							/*9*/	sentenciaStore.registerOutParameter("Var_FolioSalida", Types.BIGINT);

							/*10*/	sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							/*11*/	sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							/*12*/	sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							/*13*/	sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							/*14*/	sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							/*15*/	sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
					    	/*16*/	sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
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
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificar cuentas sucursal", e);
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


}
