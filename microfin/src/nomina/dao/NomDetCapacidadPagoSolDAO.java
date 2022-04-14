package nomina.dao;

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
import nomina.bean.NomDetCapacidadPagoSolBean;
import nomina.bean.NomTipoClavePresupBean;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

public class NomDetCapacidadPagoSolDAO extends BaseDAO{

	/*********************************************************************************************************************/
	/********** METODO PARA DAR DE ALTA LOS DETALLE DE CLAVE PRESUPUESTALES POR SU CLASIFICAICON POR SOLICITUD ***********/
	public MensajeTransaccionBean detCapacidPagoSolAlt(final NomDetCapacidadPagoSolBean nomDetCapacidadPagoSolBean, final long numTransacion)  {
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		try {
			// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "CALL NOMDETCAPACIDADPAGOSOLALT( ?,?,?,?,?,  " +
																	"?,?,?,?,?, " +
																	"?,?,?,?,?, " +
																	"?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setLong("Par_NomCapacidadPagoSolID",Utileria.convierteLong(nomDetCapacidadPagoSolBean.getNomCapacidadPagoSolID()));
					sentenciaStore.setInt("Par_ClasifClavePresupID",Utileria.convierteEntero(nomDetCapacidadPagoSolBean.getClasifClavePresupID()));
					sentenciaStore.setString("Par_DescClasifClavePresup",nomDetCapacidadPagoSolBean.getDescClasifClavePresup());
					sentenciaStore.setInt("Par_ClavePresupID",Utileria.convierteEntero(nomDetCapacidadPagoSolBean.getClavePresupID()));
					sentenciaStore.setString("Par_Clave",nomDetCapacidadPagoSolBean.getClave());

					sentenciaStore.setString("Par_DescClavePresup",nomDetCapacidadPagoSolBean.getDescClavePresup());
					sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(nomDetCapacidadPagoSolBean.getMonto()));
					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					//Parametros de Auditoria
					sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
					sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID", "NomDetCapacidadPagoSolDAO.detCapPagoSolAlt");
					sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
					sentenciaStore.setLong("Aud_NumTransaccion", numTransacion);

					loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
					return sentenciaStore;
				}
			},new CallableStatementCallback() {
				public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
					MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
					if(callableStatement.execute()){
						ResultSet resultadosStore = callableStatement.getResultSet();

						resultadosStore.next();
						mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
						mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
						mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
						mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
					}else{
						mensajeTransaccion.setNumero(999);
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .NomDetCapacidadPagoSolDAO.detCapacidPagoSolAlt");
						mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
						mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
					}
					return mensajeTransaccion;
				}
			});
			if(mensajeBean ==  null){
				mensajeBean = new MensajeTransaccionBean();
				mensajeBean.setNumero(999);
				throw new Exception(Constantes.MSG_ERROR + " .NomClavePresupDAO.clavePresupAlt");
			}else if(mensajeBean.getNumero()!=0){
				throw new Exception(mensajeBean.getDescripcion());
			}
		} catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro de Detalle de claves presupuestales por sus clasificación por Solicitud de Credito" + e);
			e.printStackTrace();
			if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
			}
			mensajeBean.setDescripcion(e.getMessage());
		}
		return mensajeBean;
	}


	/*********************************************************************************************************************/
	/********** METODO PARA DAR DE BAJA LOS DETALLE DE CLAVE PRESUPUESTALES POR SU CLASIFICAICON POR SOLICITUD ***********/
	public MensajeTransaccionBean detCapacidPagoSolBaj(final NomDetCapacidadPagoSolBean nomDetCapacidadPagoSolBean,final int numProceso, final long numTransacion)  {
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		try {
			// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "CALL NOMDETCAPACIDADPAGOSOLBAJ( ?,?,?,?,?,  " +
																	"?,?,?,?,?, " +
																	"?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_NomCapacidadPagoSolID",Utileria.convierteEntero(nomDetCapacidadPagoSolBean.getNomCapacidadPagoSolID()));
					sentenciaStore.setInt("Par_NumBaj",numProceso);

					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					//Parametros de Auditoria
					sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
					sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID", "NomDetCapPagoSolDAO.detCapacidPagoSolBaj");
					sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
					sentenciaStore.setLong("Aud_NumTransaccion", numTransacion);

					loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
					return sentenciaStore;
				}
			},new CallableStatementCallback() {
				public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
					MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
					if(callableStatement.execute()){
						ResultSet resultadosStore = callableStatement.getResultSet();

						resultadosStore.next();
						mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
						mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
						mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
						mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
					}else{
						mensajeTransaccion.setNumero(999);
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .NomDetCapacidadPagoSolDAO.detCapacidPagoSolBaj");
						mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
						mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
					}
					return mensajeTransaccion;
				}
			});
			if(mensajeBean ==  null){
				mensajeBean = new MensajeTransaccionBean();
				mensajeBean.setNumero(999);
				throw new Exception(Constantes.MSG_ERROR + " .NomDetCapacidadPagoSolDAO.detCapacidPagoSolBaj");
			}else if(mensajeBean.getNumero()!=0){
				throw new Exception(mensajeBean.getDescripcion());
			}
		} catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Proceso de Baja los Detalle de claves presupuestales por sus numero de capacidad de pago por solicitud de Credito" + e);
			e.printStackTrace();
			if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
			}
			mensajeBean.setDescripcion(e.getMessage());
		}
		return mensajeBean;
	}


	/*********************************************************************************************************************/
	/****************** METODO PARA EL LISTADO DE LAS CLASIFICACIONES REGISTRADAS POR SOLICITUD **************************/
	public List listaClasifClavSol(final NomDetCapacidadPagoSolBean nomDetCapacidadPagoSolBean, final int tipoLista){
		List lista = null;
		try{
			String query = "call NOMDETCAPACIDADPAGOSOLLIS( ?,?,?,?,?," +
													    	"?,?,?,?,?," +
													    	"?);";
			Object[] parametros = {
				nomDetCapacidadPagoSolBean.getNomCapacidadPagoSolID(),
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"NomDetCapacidadPagoSolDAO",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMDETCAPACIDADPAGOSOLLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomDetCapacidadPagoSolBean nomDetCapacidadPagoSolBean = new NomDetCapacidadPagoSolBean();

					nomDetCapacidadPagoSolBean.setNomClasifClavPresupID(resultSet.getString("NomClasifClavPresupID"));
					nomDetCapacidadPagoSolBean.setDescripcion(resultSet.getString("Descripcion"));

					return nomDetCapacidadPagoSolBean;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista d e clasificacion clave presup  por solicitud ", e);
		}
		return lista;
	}


	/*********************************************************************************************************************/
	/****************** METODO PARA EL LISTADO DE LAS CLASIFICACIONES REGISTRADAS POR SOLICITUD **************************/
	public List listaClavPresupSol(final NomDetCapacidadPagoSolBean nomDetCapacidadPagoSolBean, final int tipoLista){
		List lista = null;
		try{
			String query = "call NOMDETCAPACIDADPAGOSOLLIS( ?,?,?,?,?," +
													    	"?,?,?,?,?," +
													    	"?);";
			Object[] parametros = {
				nomDetCapacidadPagoSolBean.getNomCapacidadPagoSolID(),
				nomDetCapacidadPagoSolBean.getClasifClavePresupID(),
				Constantes.STRING_VACIO,
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"NomDetCapacidadPagoSolDAO",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMDETCAPACIDADPAGOSOLLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomDetCapacidadPagoSolBean nomDetCapacidadPagoSolBean = new NomDetCapacidadPagoSolBean();

					nomDetCapacidadPagoSolBean.setNomClavePresupID(resultSet.getString("NomClavePresupID"));
					nomDetCapacidadPagoSolBean.setClave(resultSet.getString("Clave"));
					nomDetCapacidadPagoSolBean.setDescripcion(resultSet.getString("Descripcion"));
					nomDetCapacidadPagoSolBean.setNomClasifClavPresupID(resultSet.getString("NomClasifClavPresupID"));
					nomDetCapacidadPagoSolBean.setDescClasifClavPresup(resultSet.getString("DescClasifClavPresup"));

					return nomDetCapacidadPagoSolBean;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de clave presupuestal  por solicitud ", e);
		}
		return lista;
	}


	/*********************************************************************************************************************/
	/*********************************************************************************************************************/
	public NomDetCapacidadPagoSolBean conClavePresupCapacidadPago(final NomDetCapacidadPagoSolBean nomDetCapacidadPagoSolBean,int tipoConsulta) {
		NomDetCapacidadPagoSolBean nomDetCapacidadPagoSol = null;
		try{
			//Query con el Store Procedure
			String query = "call NOMDETCAPACIDADPAGOSOLCON(  ?,?,?,?,?," +
															"?,?,?,?,?," +
															"?);";
			Object[] parametros = {
					nomDetCapacidadPagoSolBean.getNomCapacidadPagoSolID(),
					nomDetCapacidadPagoSolBean.getClasifClavePresupID(),
					nomDetCapacidadPagoSolBean.getClavePresupID(),
					tipoConsulta,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMDETCAPACIDADPAGOSOLCON(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomDetCapacidadPagoSolBean bean = new NomDetCapacidadPagoSolBean();

					bean.setClasifClavePresupID(resultSet.getString("ClasifClavePresupID"));
					bean.setClavePresupID(resultSet.getString("ClavePresupID"));
					bean.setClave(resultSet.getString("Clave"));
					bean.setMonto(resultSet.getString("Monto"));

					return bean;
				}
			});
			nomDetCapacidadPagoSol = matches.size() > 0 ? (NomDetCapacidadPagoSolBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta del datos por capacidad pago", e);
		}
		return nomDetCapacidadPagoSol;
	}


}
