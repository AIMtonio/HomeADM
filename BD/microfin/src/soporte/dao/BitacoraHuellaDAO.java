package soporte.dao;

import java.sql.CallableStatement;
import java.util.Arrays;
import java.util.List;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import org.springframework.jdbc.core.RowMapper;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import soporte.bean.BitacoraHuellaBean;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class BitacoraHuellaDAO extends BaseDAO{

	ParametrosSesionBean parametrosSesionBean = null;

	public BitacoraHuellaDAO() {
		// TODO Auto-generated constructor stub
		super();
	}

	public MensajeTransaccionBean altaBitacora(final BitacoraHuellaBean bitacoraHuellaBean) {
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
									String query = "call BITACORAHUELLAALT(?,?,?,?,?,	 ?,?,?,?,?,		?,?,?,?,?,  ?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_NumTransaccion",Utileria.convierteEntero(bitacoraHuellaBean.getNumeroTransaccion()));
									sentenciaStore.setInt("Par_TipoOperacion",Utileria.convierteEntero(bitacoraHuellaBean.getTipoOperacion()));
									sentenciaStore.setString("Par_DescriOperacion",bitacoraHuellaBean.getDescriOperacion());
									sentenciaStore.setString("Par_TipoUsuario",bitacoraHuellaBean.getTipo());
									sentenciaStore.setInt("Par_ClienteUsuario",Utileria.convierteEntero(bitacoraHuellaBean.getClienteUsuario()));

									sentenciaStore.setString("Par_Fecha",Utileria.convierteFecha(bitacoraHuellaBean.getFecha()));
									sentenciaStore.setInt("Par_CajaID",Utileria.convierteEntero(bitacoraHuellaBean.getCaja()));
									sentenciaStore.setInt("Par_SucursalOperacion",Utileria.convierteEntero(bitacoraHuellaBean.getSucursalCteUsr()));

									//Parametros de OutPut
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria se mandan vacios ya que las  pantallas que ejecutan este metodo
									//no necesitan sesion
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(sentenciaStore.toString());
									return sentenciaStore;


								} //public sql exception
							} // new CallableStatementCreator
							,new CallableStatementCallback() {
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
								}// public
							}// CallableStatementCallback
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
					loggerSAFI.error("error en alta de Correo", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}//catch
				return mensajeBean;
			} //public Object doInTransaction
		}); //men
		return mensaje;
	}

	/*------------REPORTE DE HUELLA DIGITAL-------------*/
	public List consultaBitacoraCli(BitacoraHuellaBean bitacoraHuellaBean, int tipoReporte){
		List matches = null;
		try{
			String query = "call BITACORAHUELLAREP(?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
									tipoReporte,
									Utileria.convierteFecha(bitacoraHuellaBean.getFechaInicio()),
									Utileria.convierteFecha(bitacoraHuellaBean.getFechaFin()),
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,

									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BITACORAHUELLAREP(" + Arrays.toString(parametros) +")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					BitacoraHuellaBean bitacoraHuellaBean = new BitacoraHuellaBean();

					bitacoraHuellaBean.setNombreUsuario(resultSet.getString("NombreCompleto"));
					bitacoraHuellaBean.setUsuarioID(String.valueOf(resultSet.getInt("ClienteUsuario")));
					bitacoraHuellaBean.setTipoOperacion(String.valueOf(resultSet.getInt("TipoOperacion")));
					bitacoraHuellaBean.setDescripcionOperacion(String.valueOf(resultSet.getString("DescriOperacion")));
					bitacoraHuellaBean.setCajaID(resultSet.getString("CajaID"));
					bitacoraHuellaBean.setSucursalOperacion(resultSet.getString("SucursalOperacion"));
					bitacoraHuellaBean.setNombreSucursal(resultSet.getString("NombreSucurs"));
					bitacoraHuellaBean.setFecha(resultSet.getString("Fecha"));
					bitacoraHuellaBean.setHora(resultSet.getString("Hora"));
					return bitacoraHuellaBean;
				}
			});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de REPBITACORAHUELLA", e);
		}
		return matches;
	}

	public List consultaBitacoraUsr(BitacoraHuellaBean bitacoraHuellaBean, int tipoReporte){
		List matches = null;
		try{
			String query = "call BITACORAHUELLAREP(?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
									tipoReporte,
									Utileria.convierteFecha(bitacoraHuellaBean.getFechaInicio()),
									Utileria.convierteFecha(bitacoraHuellaBean.getFechaFin()),
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,

									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BITACORAHUELLAREP(" + Arrays.toString(parametros) +")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					BitacoraHuellaBean bitacoraHuellaBean = new BitacoraHuellaBean();

					bitacoraHuellaBean.setNombreUsuario(resultSet.getString("NombreCompleto"));
					bitacoraHuellaBean.setUsuarioID(String.valueOf(resultSet.getInt("ClienteUsuario")));
					bitacoraHuellaBean.setDescripcionOperacion(String.valueOf(resultSet.getString("DescriOperacion")));
					bitacoraHuellaBean.setSucursalOperacion(resultSet.getString("SucursalOperacion"));
					bitacoraHuellaBean.setNombreSucursal(resultSet.getString("NombreSucurs"));
					bitacoraHuellaBean.setFecha(resultSet.getString("Fecha"));
					bitacoraHuellaBean.setHora(resultSet.getString("Hora"));
					return bitacoraHuellaBean;
				}
			});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de REPBITACORAHUELLA", e);
		}
		return matches;
	}


	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}


}
