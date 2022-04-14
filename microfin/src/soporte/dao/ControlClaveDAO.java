package soporte.dao;
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
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import com.efisys.pakal.*;

import soporte.bean.ControlClaveBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ControlClaveDAO extends BaseDAO{
	private String origenDatos;
	public ControlClaveDAO(){
		super();
	}


	public MensajeTransaccionBean guardarClaves(final ControlClaveBean controlClaveBean){
		//MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccionOpeInusuales(controlClaveBean.getOrigenDatos());
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		try {
			mensajeBean = bajaClaveActivacion(controlClaveBean);
			if(mensajeBean.getNumero()!=0){
				mensajeBean.setDescripcion("Verifique la Informacion Capturada");
				throw new Exception(mensajeBean.getDescripcion());
			}

			/*Se insertan los archivos Adjuntos*/
			if (controlClaveBean.getLisClaveKey() != null  && controlClaveBean.getLisClaveKey().size() > 0 ) {
				// alta de archivos
				for (int i=0; i < controlClaveBean.getLisClaveKey().size(); i++){
					if (!String.valueOf(controlClaveBean.getLisClaveKey().get(i)).isEmpty()){
						ControlClaveBean control = new ControlClaveBean();
						control.setClienteID(controlClaveBean.getClienteID());
						control.setAnio(controlClaveBean.getAnio());
						control.setMes(String.valueOf(controlClaveBean.getLisMes().get(i)));
						control.setClaveKey(String.valueOf(controlClaveBean.getLisClaveKey().get(i)));
						control.setOrigenDatos(controlClaveBean.getOrigenDatos());
						mensajeBean = altaClaveActivacion(control);
						if(mensajeBean.getNumero()!=0){
							mensajeBean.setDescripcion("Verifique la Información Capturada");
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				}
			}
			mensajeBean.setNumero(Constantes.ENTERO_CERO);
			mensajeBean.setDescripcion("Claves Guardadas Exitosamente.");
			mensajeBean.setNombreControl("clienteID");
		} catch (Exception e) {
			if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
			}
			mensajeBean.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Claves de Acceso" + e);
		}
		return mensajeBean;
	}

	public MensajeTransaccionBean altaClaveActivacion(final ControlClaveBean ctrlClaveBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//transaccionDAO.generaNumeroTransaccion();
		transaccionDAO.generaNumeroTransaccionOpeInusuales(ctrlClaveBean.getOrigenDatos());
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(ctrlClaveBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(ctrlClaveBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CONTROLCLAVEALT(" +
										"?,?,?,?,	?,?,?," +
										"?,?,?,?,	?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_ClienteID",ctrlClaveBean.getClienteID());
								sentenciaStore.setString("Par_Anio",ctrlClaveBean.getAnio());
								sentenciaStore.setString("Par_Mes",ctrlClaveBean.getMes());
								sentenciaStore.setString("Par_ClaveKey",ctrlClaveBean.getClaveKey());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
						});
					if(mensajeBean ==  null){
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
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Claves de Aceso", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/* Baja de Claves Mensuales */
	public MensajeTransaccionBean bajaClaveActivacion(ControlClaveBean ctrlClaveBean) {
		String query = "call CONTROLCLAVEBAJ(?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
					ctrlClaveBean.getClienteID(),
					ctrlClaveBean.getAnio(),

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"ControlClaveDAO.bajaClaveActivacion",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONTROLCLAVEBAJ(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(ctrlClaveBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
				mensaje.setDescripcion(resultSet.getString(2));
				mensaje.setNombreControl(resultSet.getString(3));
				return mensaje;
			}
		});

		return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
	}

	/* Consulta para obtener la fecha del Servidor de BD */
	public ControlClaveBean consultaFecha(int tipoConsulta, ControlClaveBean ctrlClaveBean) {
		//Query con el Store Procedure
		String query = "call CONTROLCLAVECON(?,  ?,?,?,  ?,?,?,?);";
		Object[] parametros = {
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONTROLCLAVECON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ControlClaveBean control = new ControlClaveBean();
				control.setAnio(resultSet.getString(1));
				control.setMes(resultSet.getString(2));
				return control;
			}
		});
		return matches.size() > 0 ? (ControlClaveBean) matches.get(0) : null;
	}

	public ControlClaveBean consultaFechaExterna(int tipoConsulta, ControlClaveBean ctrlClaveBean) {
		//Query con el Store Procedure
		String query = "call CONTROLCLAVECON(?,  ?,?,?,  ?,?,?,?);";
		Object[] parametros = {
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(ctrlClaveBean.getOrigenDatos()+"-"+"call CONTROLCLAVECON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(ctrlClaveBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ControlClaveBean control = new ControlClaveBean();
				control.setAnio(resultSet.getString(1));
				control.setMes(resultSet.getString(2));
				return control;
			}
		});
		return matches.size() > 0 ? (ControlClaveBean) matches.get(0) : null;
	}

	/* Consulta para validar la Clave Key */
	public ControlClaveBean validaClaveKey(int tipoConsulta, ControlClaveBean ctrlClaveBean) {
		 ControlClaveBean controlBean = new ControlClaveBean();
		 String auxBandera = "";
		int numConsulta = 5;
		origenDatos=ctrlClaveBean.getOrigenDatos();
		controlBean = consultaValidaClave(numConsulta);
		//Validamos si se valida o no la Clave
		try {
			 Verifica oVerifica = new Verifica();
			 //boolean oKey=oVerifica.VerificaONo("CAJA3REYES", cadena, "SI");
			 //	 NO
			 boolean oKey=oVerifica.VerificaONo(controlBean.getClienteID(), controlBean.getValidaClaveKey(), "NO");


			 //if (!oKey){
			 if (!oKey){
				 loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"SI VERIFICA = "+oKey);
				// La Clave Indica que SI hay que validar
//				System.out.println("Si Validar");
			 	// Obtener la clave del mes correspondiente guardado en la tabla CONTROLCLAVE
				ControlClaveBean controlValidaBean = new ControlClaveBean();

				controlValidaBean = consultaClavekey(tipoConsulta);
				try{
					if (controlValidaBean != null){
						revisapagomes oRevisaPago=new revisapagomes();
						//if (oRevisaPago.revisar("CAJA3REYES",	 "201408", cadena)){



						if (oRevisaPago.revisar(controlValidaBean.getClienteID(), controlValidaBean.getAnioMes(), controlValidaBean.getClaveKey())) {
							System.out.println("LICENCIA ACTIVA " + controlValidaBean.getAnioMes());
							auxBandera  = Constantes.STRING_SI;
							//controlBean.setActivo(Constantes.STRING_SI);
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"LICENCIA ACTIVA");
						}else{
//							System.out.println("LICENCIA IN-ACTIVA");
							auxBandera  = Constantes.STRING_NO;
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"LICENCIA IN-ACTIVA");
						}
					}else{
						auxBandera  = Constantes.STRING_NO;
//						System.out.println("No Hay Clave Para El Mes En Curso");
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"No Hay Clave Para El Mes En Curso");
					}
				}catch(Exception e){
					auxBandera  = Constantes.STRING_NO;
					//System.out.println("Error al validar Licencia Clave");
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al validar Licencia Clave");
					e.printStackTrace();
				}
			 }else{
				 //La Clave Indica que NO hay que validar
//				 System.out.println("No Validar");
				 auxBandera  = Constantes.STRING_SI;
			 }

		} catch (Exception e){
			//System.out.println("LICENCIA IN-ACTIVA POR EXCEPCION");
			auxBandera  = Constantes.STRING_NO;
		}
		controlBean.setActivo(auxBandera);
		return controlBean;
	}

	public ControlClaveBean consultaValidaClave(int tipoConsulta){

		//Query con el Store Procedure
				String query = "call CONTROLCLAVECON(?,  ?,?,?, ?,?,?, ?);";
				Object[] parametros = {
										tipoConsulta,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"ControlClaveDAO.consultaClavekey",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO
									};
				loggerSAFI.info(origenDatos+"-"+"call CONTROLCLAVECON(" + Arrays.toString(parametros) + ")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(origenDatos)).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ControlClaveBean control = new ControlClaveBean();
						control.setValidaClaveKey(resultSet.getString(1));
						control.setClienteID(resultSet.getString(2));
						return control;
					}
				});
				return matches.size() > 0 ? (ControlClaveBean) matches.get(0) : null;
	}


	/* Consulta para obtener la Clave Key*/
	public ControlClaveBean consultaClavekey(int tipoConsulta){
		//Query con el Store Procedure
		String query = "call CONTROLCLAVECON(?,  ?,?,?, ?,?,?, ?);";
		Object[] parametros = {
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ControlClaveDAO.consultaClavekey",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(origenDatos+"-"+"call CONTROLCLAVECON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(origenDatos)).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ControlClaveBean control = new ControlClaveBean();
				control.setClienteID(resultSet.getString(1));
				control.setAnioMes(resultSet.getString(2));
				control.setClaveKey(resultSet.getString(3));
				return control;
			}
		});
		return matches.size() > 0 ? (ControlClaveBean) matches.get(0) : null;
	}


	public List lista(ControlClaveBean controlClaveBean, int tipoLista){
		String query = "call CONTROLCLAVELIS(?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
					controlClaveBean.getClienteID(),
					controlClaveBean.getAnio(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ControlClaveDAO.lista",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONTROLCLAVELIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(controlClaveBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ControlClaveBean clavesBean = new ControlClaveBean();
				clavesBean.setClienteID(resultSet.getString(1));
				clavesBean.setAnio(resultSet.getString(2));
				clavesBean.setMes(resultSet.getString(3));
				clavesBean.setClaveKey(resultSet.getString(4));
				clavesBean.setDescMes(resultSet.getString(5));
				return clavesBean;
			}
		});
		return matches;
	}
}
