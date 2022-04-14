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

import nomina.bean.NomClasifClavePresupBean;
import nomina.bean.NomClavePresupBean;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

public class NomClavePresupDAO extends BaseDAO{

	NomClasifClavePresupDAO nomClasifClavePresupDAO = null;

	/*********************************************************************************************************************/
	/*********************************** METODO PARA DAR DE ALTA LOS CLAVES PRESUPUESTALES *******************************/
	public MensajeTransaccionBean nomClavePresupAlt(final NomClavePresupBean nomClavePresupBean, final long numTransacion)  {
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		try {
			// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "CALL NOMCLAVEPRESUPALT( ?,?,?,?,?,  " +
															"?,?,?,?,?, " +
															"?,?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_NomTipoClavePresupID",Utileria.convierteEntero(nomClavePresupBean.getTipoClavePresupID()));
					sentenciaStore.setString("Par_Clave",nomClavePresupBean.getClave());
					sentenciaStore.setString("Par_Descripcion",nomClavePresupBean.getDescripcion());

					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					//Parametros de Auditoria
					sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
					sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID", "NomClavePresupDAO.clavePresupAlt");
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
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .NomClavePresupDAO.clavePresupAlt");
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
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro de Clave Presupuestal" + e);
			e.printStackTrace();
			if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
			}
			mensajeBean.setDescripcion(e.getMessage());
		}
		return mensajeBean;
	}

	/*********************************************************************************************************************/
	/*********************************** METODO PARA DAR DE ALTA LOS CLAVES PRESUPUESTALES *******************************/
	public MensajeTransaccionBean nomClavePresupMod(final NomClavePresupBean nomClavePresupBean, final long numTransacion)  {
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		try {
			// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "CALL NOMCLAVEPRESUPMOD(?,?,?,?,  ?,?,?,  ?,?,?,?,?,?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_NomClavePresupID", Utileria.convierteEntero(nomClavePresupBean.getNomClavePresupID()));
					sentenciaStore.setInt("Par_NomTipoClavePresupID",Utileria.convierteEntero(nomClavePresupBean.getTipoClavePresupID()));
					sentenciaStore.setString("Par_Clave",nomClavePresupBean.getClave());
					sentenciaStore.setString("Par_Descripcion",nomClavePresupBean.getDescripcion());

					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					//Parametros de Auditoria
					sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
					sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID", "NomClavePresupDAO.clavePresupAlt");
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
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .NomClavePresupDAO.nomClavePresupMod");
						mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
						mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
					}
					return mensajeTransaccion;
				}
			});
			if(mensajeBean ==  null){
				mensajeBean = new MensajeTransaccionBean();
				mensajeBean.setNumero(999);
				throw new Exception(Constantes.MSG_ERROR + " .NomClavePresupDAO.nomClavePresupMod");
			}else if(mensajeBean.getNumero()!=0){
				throw new Exception(mensajeBean.getDescripcion());
			}
		} catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la modificacion de Clave Presupuestal" + e);
			e.printStackTrace();
			if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
			}
			mensajeBean.setDescripcion(e.getMessage());
		}
		return mensajeBean;
	}

	/*********************************************************************************************************************/
	/***************************** METODO PARA DAR DE BAJA LOS CLAVES PRESUPUESTALES MASIVAMENTE *************************/
	public MensajeTransaccionBean clavePresupBaja(final NomClavePresupBean nomClavePresupBean,final int numProceso, final long numTransacion)  {
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		try {
			// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "CALL NOMCLAVEPRESUPBAJ( ?,?,?,?,?,  " +
															"?,?,?,?,?, " +
															"?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_NomClavePresupID",Constantes.ENTERO_CERO);
					sentenciaStore.setInt("Par_NumBaj",numProceso);

					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					//Parametros de Auditoria
					sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
					sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID", "NomClavePresupDAO.clavePresupBaja");
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
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .NomClavePresupDAO.clavePresupBaja");
						mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
						mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
					}
					return mensajeTransaccion;
				}
			});
			if(mensajeBean ==  null){
				mensajeBean = new MensajeTransaccionBean();
				mensajeBean.setNumero(999);
				throw new Exception(Constantes.MSG_ERROR + " .NomClavePresupDAO.clavePresupBaja");
			}else if(mensajeBean.getNumero()!=0){
				throw new Exception(mensajeBean.getDescripcion());
			}
		} catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Proceso de Baja Masiva de Clave Presupuestal" + e);
			e.printStackTrace();
			if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
			}
			mensajeBean.setDescripcion(e.getMessage());
		}
		return mensajeBean;
	}

	/*********************************************************************************************************************/
	/************************************* METODO PARA DAR DE BAJA UNA CLAVES PRESUPUESTAL********************************/
	public MensajeTransaccionBean nomClavePresupBaja(final NomClavePresupBean nomClavePresupBean,final int numProceso, final long numTransacion)  {
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		try {
			// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "CALL NOMCLAVEPRESUPBAJ( ?,?,?,?,?,  " +
															"?,?,?,?,?, " +
															"?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_NomClavePresupID", Utileria.convierteEntero(nomClavePresupBean.getNomClavePresupID()));
					sentenciaStore.setInt("Par_NumBaj",numProceso);

					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					//Parametros de Auditoria
					sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
					sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID", "NomClavePresupDAO.clavePresupBaja");
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
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .NomClavePresupDAO.nomClavePresupBaja");
						mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
						mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
					}
					return mensajeTransaccion;
				}
			});
			if(mensajeBean ==  null){
				mensajeBean = new MensajeTransaccionBean();
				mensajeBean.setNumero(999);
				throw new Exception(Constantes.MSG_ERROR + " .NomClavePresupDAO.clavePresupBaja");
			}else if(mensajeBean.getNumero()!=0){
				throw new Exception(mensajeBean.getDescripcion());
			}
		} catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Proceso de Baja Masiva de Clave Presupuestal" + e);
			e.printStackTrace();
			if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
			}
			mensajeBean.setDescripcion(e.getMessage());
		}
		return mensajeBean;
	}


	/*********************************************************************************************************************/
	/****************************** METODO PARA EL LISTADO DE LOS CLAVES PRESUPUESTALES **********************************/
	public List listaClavePresup(final NomClavePresupBean nomClavePresupBean, final int tipoLista){
		List lista = null;
		try{
			String query = "call NOMCLAVEPRESUPLIS( ?,?,?,?,?," +
													"?,?,?,?);";
			Object[] parametros = {
				Constantes.ENTERO_CERO,
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"NomTipoClavePresupDAO.listaClavePresup",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMCLAVEPRESUPLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomClavePresupBean nomClavePresupBean = new NomClavePresupBean();

					nomClavePresupBean.setNomClavePresupID(resultSet.getString("NomClavePresupID"));
					nomClavePresupBean.setTipoClavePresupID(resultSet.getString("NomTipoClavePresupID"));
					nomClavePresupBean.setClave(resultSet.getString("Clave"));
					nomClavePresupBean.setDescripcion(resultSet.getString("Descripcion"));
					nomClavePresupBean.setNomClasifClavPresupID(resultSet.getString("NomClasifClavPresupID"));

					return nomClavePresupBean;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Tipos de claves Presupuestales ", e);
		}
		return lista;
	}


	/*********************************************************************************************************************/
	/***************************** METODO PARA EL LISTADO DE LOS CLAVES PRESUPUESTALES COMBOS ****************************/
	public List listaClavePresupCombo(final NomClavePresupBean nomClavePresupBean, final int tipoLista){
		List lista = null;
		try{
			String query = "call NOMCLAVEPRESUPLIS( ?,?,?,?,?," +
													"?,?,?,?);";
			Object[] parametros = {
				Constantes.ENTERO_CERO,
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"NomTipoClavePresupDAO.listaClavePresupCombo",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMCLAVEPRESUPLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomClavePresupBean nomClavePresupBean = new NomClavePresupBean();

					nomClavePresupBean.setNomClavePresupID(resultSet.getString("NomClavePresupID"));
					nomClavePresupBean.setDescripcion(resultSet.getString("Descripcion"));

					return nomClavePresupBean;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Tipos de claves Presupuestales Combo ", e);
		}
		return lista;
	}

	/*********************************************************************************************************************/
	/***************************** METODO PARA EL LISTADO DE LOS CLAVES PRESUPUESTALES GRID ******************************/
	public List listaClavePresupGrid(final NomClavePresupBean nomClavePresupBean, final int tipoLista){
		List lista = null;
		try{
			String query = "call NOMCLAVEPRESUPLIS( ?,?,?,?,?," +
													"?,?,?,?);";
			Object[] parametros = {
				Constantes.ENTERO_CERO,
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"NomTipoClavePresupDAO.listaClavePresupGrid",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMCLAVEPRESUPLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomClavePresupBean nomClavePresupBean = new NomClavePresupBean();

					nomClavePresupBean.setNomClavePresupID(resultSet.getString("NomClavePresupID"));
					nomClavePresupBean.setClave(resultSet.getString("Clave"));
					nomClavePresupBean.setDescripcion(resultSet.getString("Descripcion"));

					return nomClavePresupBean;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Tipos de claves Presupuestales Grid ", e);
		}
		return lista;
	}


	/*********************************************************************************************************************/
	/***************************** METODO PRINCIPAL PARA EL ALTA MASIVA DE DE CLAVES PRESUPUESTALES **********************/
	public MensajeTransaccionBean altaClavePresup(final NomClavePresupBean nomClavePresupBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				int numProceso = 2;	// Baja por ID de Clave Presupuestal
				String idClavePresupMod = null;
				NomClavePresupBean nomClavePresupBeanBaj = null;
				NomClavePresupBean nomClavePresupBeanMod = null;
				NomClavePresupBean nomClavePresupBeanAlt = null;
				try {
					// Damos de baja las claves presupuestales.
					for(int i=0; nomClavePresupBean.getNomClavePresupBajID() !=null && i < nomClavePresupBean.getNomClavePresupBajID().length; i++) {
						nomClavePresupBeanBaj = new NomClavePresupBean();
						nomClavePresupBeanBaj.setNomClavePresupID(nomClavePresupBean.getNomClavePresupBajID()[i]);

						mensajeBean = nomClavePresupBaja(nomClavePresupBeanBaj,numProceso, parametrosAuditoriaBean.getNumeroTransaccion() );
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					//Modificacion o Alta de Claves Presupuestales.
					String[] idClavePresup = nomClavePresupBean.getClavesPresupID();
					String[] nomTipoClavePresupID = nomClavePresupBean.getTiposClavePresupID();
					String[] descripcion = nomClavePresupBean.getDesClavePresup();
					String[] clave = nomClavePresupBean.getClavePresup();

					for(int i = 0; nomTipoClavePresupID !=null && i < nomTipoClavePresupID.length; i++){
						//Se trata del registro de una nueva clave presupuestal
						if(Constantes.STRING_CERO.equals(idClavePresup[i])) {
							nomClavePresupBeanAlt = new NomClavePresupBean();
							nomClavePresupBeanAlt.setTipoClavePresupID(nomTipoClavePresupID[i]);
							nomClavePresupBeanAlt.setClave(clave[i]);
							nomClavePresupBeanAlt.setDescripcion(descripcion[i]);

							mensajeBean = nomClavePresupAlt(nomClavePresupBeanAlt,parametrosAuditoriaBean.getNumeroTransaccion());
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
						//Clave presupuestal existente
						else {
							// Revisamos que se trate de una clave presupuestal a modificar
							for(int j = 0; nomClavePresupBean.getNomClavePresupModID() != null && j < nomClavePresupBean.getNomClavePresupModID().length ; j++){
								idClavePresupMod = nomClavePresupBean.getNomClavePresupModID()[j];
								if(!idClavePresupMod.equals(idClavePresup[i])) {
									continue;
								}

								nomClavePresupBeanMod = new NomClavePresupBean();
								nomClavePresupBeanMod.setNomClavePresupID(idClavePresup[i]);
								nomClavePresupBeanMod.setTipoClavePresupID(nomTipoClavePresupID[i]);
								nomClavePresupBeanMod.setClave(clave[i]);
								nomClavePresupBeanMod.setDescripcion(descripcion[i]);

								mensajeBean = nomClavePresupMod(nomClavePresupBeanMod,parametrosAuditoriaBean.getNumeroTransaccion());

								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						}
					}

					//Proceso exitoso
					mensajeBean.setNumero(Constantes.ENTERO_CERO);
					mensajeBean.setDescripcion("Proceso Realizado Correctamente.");
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al dar de alta de Claves Presupuestales", e);
					if(mensajeBean.getNumero()==0){
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

	/*********************************************************************************************************************/
	/***************************** METODO PARA DAR DE ALTA LAS CLASIFICACIONES PRESUPUESTALES ****************************/
	public MensajeTransaccionBean altaClasifClavePresup(final NomClavePresupBean nomClavePresupBean)  {
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		try {

			NomClasifClavePresupBean nomClasifClavePresupBean = new NomClasifClavePresupBean();
			nomClasifClavePresupBean.setDescripcion(nomClavePresupBean.getDescripClasifClave());
			nomClasifClavePresupBean.setPrioridad(nomClavePresupBean.getPrioridad());
			nomClasifClavePresupBean.setNomClavePresupID(nomClavePresupBean.getNomClavesPresupID());

			if(nomClasifClavePresupBean.getNomClavePresupID().length() > 3000){
				mensajeBean.setNumero(999);
				mensajeBean.setDescripcion("La cadena de la clave presupestal tiene mas de 3000 caracteres");

				return mensajeBean;

			}
			mensajeBean = nomClasifClavePresupDAO.clasifClavePresupAlt(nomClasifClavePresupBean);

			if(mensajeBean.getNumero()!=0){
				throw new Exception(mensajeBean.getDescripcion());
			}

		} catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Proceso de Alta de Clasificacion Clave Presupuestal" + e);
			e.printStackTrace();
			if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
			}
			mensajeBean.setDescripcion(e.getMessage());
		}
		return mensajeBean;
	}

	/*********************************************************************************************************************/
	/******************************* METODO PARA MODIFICAR LAS CLASIFICACIONES PRESUPUESTALES ****************************/
	public MensajeTransaccionBean modClasifClavePresup(final NomClavePresupBean nomClavePresupBean)  {
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		try {

			NomClasifClavePresupBean nomClasifClavePresupBean = new NomClasifClavePresupBean();


			nomClasifClavePresupBean.setNomClasifClavPresupID(nomClavePresupBean.getNomClasifClavPresupID());
			nomClasifClavePresupBean.setEstatus(nomClavePresupBean.getEstatus());
			nomClasifClavePresupBean.setDescripcion(nomClavePresupBean.getDescripClasifClave());
			nomClasifClavePresupBean.setPrioridad(nomClavePresupBean.getPrioridad());
			nomClasifClavePresupBean.setNomClavePresupID(nomClavePresupBean.getNomClavesPresupID());
			if(nomClasifClavePresupBean.getNomClavePresupID().length() > 3000){
				mensajeBean.setNumero(999);
				mensajeBean.setDescripcion("La cadena de la clave presupestal tiene mas de 3000 caracteres");

				return mensajeBean;
			}
			mensajeBean = nomClasifClavePresupDAO.clasifClavePresupMod(nomClasifClavePresupBean);

			if(mensajeBean.getNumero()!=0){
				throw new Exception(mensajeBean.getDescripcion());
			}

		} catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Proceso de Modifica de Clasificacion Clave Presupuestal" + e);
			e.printStackTrace();
			if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
			}
			mensajeBean.setDescripcion(e.getMessage());
		}
		return mensajeBean;
	}


	public NomClasifClavePresupDAO getNomClasifClavePresupDAO() {
		return nomClasifClavePresupDAO;
	}

	public void setNomClasifClavePresupDAO(
			NomClasifClavePresupDAO nomClasifClavePresupDAO) {
		this.nomClasifClavePresupDAO = nomClasifClavePresupDAO;
	}

}
