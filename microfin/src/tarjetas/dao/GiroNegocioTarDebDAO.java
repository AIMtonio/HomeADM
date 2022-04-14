package tarjetas.dao;
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

import tarjetas.bean.GiroNegocioTarDebBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class GiroNegocioTarDebDAO extends BaseDAO{

	public GiroNegocioTarDebDAO() {
		super();
	}

	/* Lista tipo de tarjetas de Debito */
	public List listaPrincipal(GiroNegocioTarDebBean giroNegocioTarDebBean, int tipoLista) {
		List listaPrincipal=null;
		try{
		String query = "call TARDEBGINEGISOLIS(?,?,   ?,?,?,?,?,?,?);";
		Object[] parametros = {
								giroNegocioTarDebBean.getGiroID(),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TARDEBGINEGISOLIS.listaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBGINEGISOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				GiroNegocioTarDebBean giroNegocioTarDebBean = new GiroNegocioTarDebBean();
				giroNegocioTarDebBean.setGiroID(resultSet.getString("GiroID"));
				giroNegocioTarDebBean.setDescripcion(resultSet.getString("Descripcion"));
				return giroNegocioTarDebBean;
			}
		});

		listaPrincipal= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista principal de tarjeta de debito", e);
		}
		return listaPrincipal;
	}

////---------------------------tipo de tarjeta debito-----------------
	//-------------------------------insertar tipo de tarjeta---------------------------
public MensajeTransaccionBean giroTardeb(final int tipoTransaccion, final GiroNegocioTarDebBean giroNegocioTarDebBean) {
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
								String query = "call TARDEBGINEGISOALT(?,?,?,?,       ?,?,?,?,    ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_GiroID",giroNegocioTarDebBean.getGiroID());
								sentenciaStore.setString("Par_Descripcion",giroNegocioTarDebBean.getDescripcion());
								sentenciaStore.setString("Par_NombreCorto",giroNegocioTarDebBean.getNombreCorto());
								sentenciaStore.setString("Par_Estatus",giroNegocioTarDebBean.getEstatus());

								sentenciaStore.setInt("Par_TipoTran",tipoTransaccion);
								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
								// Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cuentas de personal", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

//------------------------------------consulta de tipo de tarjeta debito  ----------------------
	public GiroNegocioTarDebBean consultaGiroNegocioTarDeb(int tipoConsulta,GiroNegocioTarDebBean giroNegocioTarDebBean){

		String query = "call TARDEBGINEGISOCON(?,?,   ?,?,?,?,?,?,?);";

		Object[] parametros = {
				giroNegocioTarDebBean.getGiroID(),

				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TARDEBGINEGISOCON.consultaTipoTarjetaDebito",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBGINEGISOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GiroNegocioTarDebBean giroNegocioTarDebBean= new GiroNegocioTarDebBean();
				giroNegocioTarDebBean.setGiroID(resultSet.getString(1));
				giroNegocioTarDebBean.setDescripcion(resultSet.getString(2));
				giroNegocioTarDebBean.setNombreCorto(resultSet.getString(3));
				giroNegocioTarDebBean.setEstatus(resultSet.getString(4));
				return giroNegocioTarDebBean;
			}
		});
		return matches.size() > 0 ? (GiroNegocioTarDebBean) matches.get(0) : null;
	}

	//------------- Modificar tipo de tarjeta debito----------------------
	/* Modificacion de tipo de tarjeta debito */

	public MensajeTransaccionBean modtipoGiroNeg(final GiroNegocioTarDebBean giroNegocioTarDebBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					String query = "call TARDEBGINEGISOMOD(?,?,?,?,  ?,?,?,?,?,?,?);";
					Object[] parametros = {
							giroNegocioTarDebBean.getGiroID(),
							giroNegocioTarDebBean.getDescripcion(),
							giroNegocioTarDebBean.getNombreCorto(),
							giroNegocioTarDebBean.getEstatus(),

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"TARDEBGINEGISOMOD.modifica",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBGINEGISOMOD(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							mensaje.setConsecutivoString(resultSet.getString(4));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de plazas", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
}
