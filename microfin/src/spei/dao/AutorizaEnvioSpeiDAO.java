package spei.dao;

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
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import spei.bean.AutorizaEnvioSpeiBean;

public class AutorizaEnvioSpeiDAO extends BaseDAO  {

	AutorizaEnvioSpeiDAO autorizaEnvioSpeiDAO = null;

	public AutorizaEnvioSpeiDAO() {
		super();
	}



	// Actualiza el estatus
	public MensajeTransaccionBean autorizaEnvioSpei(final AutorizaEnvioSpeiBean autorizaEnvioSpeiBean, final int tipoActualizacion) {
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
								String query = "call SPEIENVIOSACT(?,?,?,?,?, ?,?,?,?,?,"
																+ "?,?,?,?,?, ?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_Folio",autorizaEnvioSpeiBean.getFolioSpeiID());
								sentenciaStore.setString("Par_ClaveRastreo",autorizaEnvioSpeiBean.getClaveRastreo());
								sentenciaStore.setInt("Par_EstatusEnv",Constantes.ENTERO_CERO);//revisar este parametros
								sentenciaStore.setInt("Par_CausaDevol",Constantes.ENTERO_CERO);

								sentenciaStore.setString("Par_Comentario",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_UsuarioEnvio",autorizaEnvioSpeiBean.getUsuarioEnvio());
								sentenciaStore.setString("Par_UsuarioAutoriza",autorizaEnvioSpeiBean.getUsuarioAutoriza());
								sentenciaStore.setString("Par_UsuarioVerifica",autorizaEnvioSpeiBean.getUsuarioVerifica());
								sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la actualizacion de Envio Spei", e);
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


	   public MensajeTransaccionBean actualizaListaCodigosResp(AutorizaEnvioSpeiBean autorizaEnvioSpeiBean, int tipoTransaccion, final List listaCodigosResp) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

					try {
						AutorizaEnvioSpeiBean autorizaEnvioSpeiBean;
						  String consecutivo= mensajeBean.getConsecutivoString();
						  int tipoTransaccion=9;
							for(int i=0; i<listaCodigosResp.size(); i++){

								autorizaEnvioSpeiBean = (AutorizaEnvioSpeiBean)listaCodigosResp.get(i);
								mensajeBean = autorizaEnvioSpei(autorizaEnvioSpeiBean, tipoTransaccion);

								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}

					} catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al actualizar lista de codigos", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}




/* lista para traer los envios con estatus P */
	public List listaAutTeso(AutorizaEnvioSpeiBean autorizaEnvioSpeiBean, int tipoLista){
		String query = "call SPEIENVIOSLIS(?,?,?,?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
					autorizaEnvioSpeiBean.getFolio(),
					autorizaEnvioSpeiBean.getClienteID(),
					autorizaEnvioSpeiBean.getFechaIncial(),
					autorizaEnvioSpeiBean.getFechaFinal(),
					autorizaEnvioSpeiBean.getTipoBusqueda(),
					Constantes.STRING_VACIO,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					Constantes.STRING_VACIO,
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SPEIENVIOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AutorizaEnvioSpeiBean autorizaEnvioSpeiBean = new AutorizaEnvioSpeiBean();
				autorizaEnvioSpeiBean.setFolioSpeiID(resultSet.getString(1));
				autorizaEnvioSpeiBean.setCuentaOrd(resultSet.getString(2));
				autorizaEnvioSpeiBean.setCuentaBeneficiario(resultSet.getString(3));
				autorizaEnvioSpeiBean.setNombreBeneficiario(resultSet.getString(4));
				autorizaEnvioSpeiBean.setClaveRastreo(resultSet.getString(5));
				autorizaEnvioSpeiBean.setMonto(resultSet.getString(6));

				return autorizaEnvioSpeiBean;


			}
		});
		return matches;
	}



	public AutorizaEnvioSpeiDAO getAutorizaEnvioSpeiDAO() {
		return autorizaEnvioSpeiDAO;
	}



	public void setAutorizaEnvioSpeiDAO(AutorizaEnvioSpeiDAO autorizaEnvioSpeiDAO) {
		this.autorizaEnvioSpeiDAO = autorizaEnvioSpeiDAO;
	}






}


