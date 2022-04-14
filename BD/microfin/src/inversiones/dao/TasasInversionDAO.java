package inversiones.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Utileria;
import inversiones.bean.TasasInversionBean;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

public class TasasInversionDAO extends BaseDAO {

	public TasasInversionDAO() {
		super();
	}

	public MensajeTransaccionBean alta(final TasasInversionBean tasasInversionBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();		
		transaccionDAO.generaNumeroTransaccion();
		
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
		
					String query = "call TASASINVERSIONALT(?,?,?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
						tasasInversionBean.getTipoInvercionID(),
						tasasInversionBean.getDiaInversionID(),
						tasasInversionBean.getMontoInversionID(),
						Utileria.convierteDoble(Float.toString(tasasInversionBean.getConceptoInversion())),
						Utileria.convierteDoble(tasasInversionBean.getGatInformativo()),
						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"TasaInversionDAO.alta",
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
						};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASINVERSIONALT(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de tasas de inversion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	public MensajeTransaccionBean modificaTasa(final TasasInversionBean tasasInversionBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();		
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
		
					String query = "call TASASINVERSIONMOD(?,?,?,?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
						Utileria.convierteEntero(tasasInversionBean.getTasaInversionID()),
						tasasInversionBean.getTipoInvercionID(),
						tasasInversionBean.getDiaInversionID(),
						tasasInversionBean.getMontoInversionID(),
						tasasInversionBean.getConceptoInversion(),
						Utileria.convierteDoble(tasasInversionBean.getGatInformativo()),
						parametrosAuditoriaBean.getEmpresaID(),
						
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"TasaInversionDAO.modificaTasa",
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
					};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASINVERSIONMOD(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de tasa de inverison", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean bajaTasa(TasasInversionBean tasasInversionBean){
		// La Baja de Tasas es llamada por la Actualizacion de Plazos y Montos
		// Estas Actualizaciones de Plazo y Monto son los que establecen el
		// Manejo de Transacciones, por eso no se ve aqui el manejo de Transacciones
		
		String query = "call TASASINVERSIONBAJ(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(tasasInversionBean.getTasaInversionID()),
				tasasInversionBean.getTipoInvercionID(),
				parametrosAuditoriaBean.getEmpresaID(),
				
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"DiasInversionDAO.bajaTasa",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASINVERSIONBAJ(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				
				mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
				mensaje.setDescripcion(resultSet.getString(2));
						
				return mensaje;
			}
		});
		return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
	}

	
	public TasasInversionBean consultaPrincipal(TasasInversionBean tasasInversion, int tipoConsulta){
		String query = "call TASASINVERSIONCON(?,?,?,?);";
		Object[] parametros = {
				tasasInversion.getTipoInvercionID(),
				tasasInversion.getDiaInversionID(),
				tasasInversion.getMontoInversionID(),
				tipoConsulta};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASINVERSIONCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			
				TasasInversionBean tasasInversionBean = new TasasInversionBean();
				
				tasasInversionBean.setTasaInversionID(Utileria.completaCerosIzquierda(resultSet.getInt(1), 5));
				tasasInversionBean.setConceptoInversion(resultSet.getFloat(2));		
				tasasInversionBean.setGatInformativo(resultSet.getString("GatInformativo"));	
				
				
				return tasasInversionBean;
				
			}
		});
		return matches.size() > 0 ? (TasasInversionBean)  matches.get(0) : null;	
	}
		
	public TasasInversionBean consultaTasa(TasasInversionBean tasasInversionBean){
		String query = "call TASASINVERSIONCAL(?,?,?);";
		
						
		Object[] parametros = {
				tasasInversionBean.getTipoInvercionID(),
				tasasInversionBean.getDiaInversionID(),
				tasasInversionBean.getMonto() };
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {				
				TasasInversionBean tasasInversion = new TasasInversionBean();				
				tasasInversion.setConceptoInversion(resultSet.getFloat(1));		
				tasasInversion.setValorGat(resultSet.getFloat("ValorGat"));
				tasasInversion.setValorGatReal(resultSet.getFloat("ValorGatReal"));
				return tasasInversion;
			}
		});
		return matches.size() > 0 ? (TasasInversionBean)  matches.get(0) : null;
	}
	

}
