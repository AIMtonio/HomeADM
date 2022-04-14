package cuentas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import cuentas.bean.MonedasBean;
import cuentas.bean.TasasAhorroBean;

import javax.sql.DataSource;

public class TasasAhorroDAO extends BaseDAO {
	
	public TasasAhorroDAO() {
		super();
	}

	public MensajeTransaccionBean alta(final TasasAhorroBean tasaAhorro) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call TASASAHORROALT(?,?,?,?,?,? ,?,?,?,?,?,?,?);";
					Object[] parametros = {
							Utileria.convierteEntero(tasaAhorro.getTipoCuentaID()),
							tasaAhorro.getTipoPersona(),
							Utileria.convierteEntero(tasaAhorro.getMonedaID()),				
							Utileria.convierteDoble(tasaAhorro.getMontoInferior()),
							Utileria.convierteDoble(tasaAhorro.getMontoSuperior()),
							Utileria.convierteDoble(tasaAhorro.getTasa()),
							
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"TasasAhorroDAO.alta",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASAHORROALT(" + Arrays.toString(parametros) +")");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de tasa de ahorro", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modifica(final TasasAhorroBean tasaAhorro){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call TASASAHORROMOD(?,?,?,?,?,?,? ,?,?,?,?,?,?,?);";
					Object[] parametros = {
							Utileria.convierteEntero(tasaAhorro.getTasaAhorroID()),
							Utileria.convierteEntero(tasaAhorro.getTipoCuentaID()),
							tasaAhorro.getTipoPersona(),
							Utileria.convierteEntero(tasaAhorro.getMonedaID()),
							Utileria.convierteDoble(tasaAhorro.getMontoInferior()),
							Utileria.convierteDoble(tasaAhorro.getMontoSuperior()),
							Utileria.convierteDoble(tasaAhorro.getTasa()),
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"TasasAhorroDAO.modifica",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASAHORROMOD(" + Arrays.toString(parametros) +")");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al modificar tasa de ahorro", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	public MensajeTransaccionBean baja(final TasasAhorroBean tasaAhorro){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call TASASAHORROBAJ(? ,?,?,?,?,?,?,?);";
					Object[] parametros = {
							Utileria.convierteEntero(tasaAhorro.getTasaAhorroID()),
							
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"TasasAhorroDAO.baja",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASAHORROBAJ(" + Arrays.toString(parametros) +")");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de tasa de ahorro", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public TasasAhorroBean consultaPrincipal(TasasAhorroBean tasaAhorro, int tipoConsulta){
		String query = "call TASASAHORROCON(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = { 
				tasaAhorro.getTasaAhorroID(),
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TasasAhorroDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASAHORROCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TasasAhorroBean tasaAhorro = new TasasAhorroBean();
				tasaAhorro.setTasaAhorroID(Utileria.completaCerosIzquierda(resultSet.getInt(1), TasasAhorroBean.LONGITUD_ID));
				tasaAhorro.setTipoCuentaID(resultSet.getString(2));
				tasaAhorro.setTipoPersona(resultSet.getString(3));
				tasaAhorro.setMonedaID(resultSet.getString(4));
				tasaAhorro.setMontoInferior(resultSet.getString(5));
				tasaAhorro.setMontoSuperior(resultSet.getString(6));
				tasaAhorro.setTasa(resultSet.getString(7));
				return tasaAhorro;
			}
		});
		return matches.size() > 0 ? (TasasAhorroBean) matches.get(0) : null;
	}
	
	//Lista de Tasas de Ahorro	
	public List listaTasasAhorro(TasasAhorroBean tasaAhorro,int tipoLista) {
		List listaTasas = null; 
		try{
			//Query con el Store Procedure
			String query = "call TASASAHORROLIS(?,?,?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = {	
					Utileria.convierteEntero(tasaAhorro.getTipoCuentaID()),
					Utileria.convierteEntero(tasaAhorro.getMonedaID()),
					tasaAhorro.getTipoPersona(),
					tipoLista,
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"TasasAhorroDAO.listaTasasAhorro",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
					};		
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASAHORROLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TasasAhorroBean tasaAhorro = new TasasAhorroBean();
					tasaAhorro.setTasaAhorroID(resultSet.getString(1));
					tasaAhorro.setMontoInferior(resultSet.getString(2));
					tasaAhorro.setMontoSuperior(resultSet.getString(3));
					tasaAhorro.setTasa(resultSet.getString(4));	
					return tasaAhorro;
				}
			});
			listaTasas =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista principal tasas ahorro ", e);
		}		
		return listaTasas;
	}
	//Lista de Tasas de Ahorro para portada de contrato cta
	public List listaPortadaContrato(TasasAhorroBean tasaAhorro,int tipoLista) {
		//Query con el Store Procedure
		
		String query = "call TASASAHORROLIS(?,?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {	
				Utileria.convierteEntero(tasaAhorro.getTipoCuentaID()),
				Utileria.convierteEntero(tasaAhorro.getMonedaID()),
				tasaAhorro.getTipoPersona(),
				tipoLista,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"TasasAhorroDAO.listaTasasAhorro",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASAHORROLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TasasAhorroBean tasaAhorro = new TasasAhorroBean();
				
				tasaAhorro.setTasaAhorroID(resultSet.getString(1));
				tasaAhorro.setMontoInferior(resultSet.getString(2));
				tasaAhorro.setMontoSuperior(resultSet.getString(3));
				tasaAhorro.setTasa(resultSet.getString(4));	
				return tasaAhorro;
			}
		});
				
		return matches;
	}
	

}

