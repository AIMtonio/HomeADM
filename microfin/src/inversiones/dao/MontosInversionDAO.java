package inversiones.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import inversiones.bean.MontoInversionBean;
import inversiones.bean.TasasInversionBean;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

public class MontosInversionDAO extends BaseDAO {
	
	// ------------------ Propiedades y Atributos ------------------------------------------
	private TasasInversionDAO tasasInversionDAO;
	
	public MontosInversionDAO() {
		super();
	}
	
	// ------------------ Transacciones ------------------------------------------
	
	public MensajeTransaccionBean altaMontoInversion(MontoInversionBean montoInversion) {
		loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Dao: "+ montoInversion.getPlazoSuperior());
		String query = "call MONTOINVERSIONALT(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(montoInversion.getTipoInversionID()),
				Utileria.convierteDoble(montoInversion.getPlazoInferior()),
				Utileria.convierteDoble(montoInversion.getPlazoSuperior()),
				parametrosAuditoriaBean.getEmpresaID(),
				
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"MontosInversionDAO.alta",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MONTOINVERSIONALT(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
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
	
	public MensajeTransaccionBean bajaMontosInversion(MontoInversionBean montoInversion) {
		String query = "call MONTOSINVERSIONBAJ(?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {
				Utileria.convierteEntero(montoInversion.getMontoInversionID()),
				Utileria.convierteEntero(montoInversion.getTipoInversionID()),
				parametrosAuditoriaBean.getEmpresaID(),
				
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"MontosInversionDAO.bajaMontosInversion",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MONTOSINVERSIONBAJ(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
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
	
	public MensajeTransaccionBean grabaListaMontosInversion(final MontoInversionBean montoInversionBean,
															final List listaMontosInversion ) {
		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					
					MontoInversionBean montoBean;
					mensajeBean = bajaMontosInversion(montoInversionBean);
					
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}					
					inversiones.bean.TasasInversionBean tasaInversion = new inversiones.bean.TasasInversionBean();
					tasaInversion.setTasaInversionID("0");
					tasaInversion.setTipoInvercionID(herramientas.Utileria.convierteEntero(
														montoInversionBean.getTipoInversionID()));
					mensajeBean = tasasInversionDAO.bajaTasa(tasaInversion);
					
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());	
					}
					
					for(int i=0; i<listaMontosInversion.size(); i++){
						montoBean = (MontoInversionBean)listaMontosInversion.get(i);
						mensajeBean = altaMontoInversion(montoBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());	
						}											
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Informacion Actualizada. NO Olvide Actualizar las Tasas de Inversion.");
					mensajeBean.setNombreControl("tipoInversionID");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en grabacion de listas de monto de inversion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	public List lista(MontoInversionBean montoInversion, int tipoLista){

		String query = "call MONTOINVERSIONLIS(?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {	Integer.valueOf(montoInversion.getTipoInversionID()),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"MontosInversionDAO.lista",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MONTOINVERSIONLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				MontoInversionBean montoInversionBean = new MontoInversionBean();
				montoInversionBean.setMontoInversionID(String.valueOf(resultSet.getInt(1)));
				montoInversionBean.setTipoInversionID(String.valueOf(resultSet.getInt(2)));
				montoInversionBean.setPlazoInferior(resultSet.getString(3));
				montoInversionBean.setPlazoSuperior(resultSet.getString(4));
				return montoInversionBean;
			}
		});
		return matches;
	}

	public List listaForanea(MontoInversionBean montoInversion, int tipoLista){

		String query = "call MONTOINVERSIONLIS(?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {	Integer.valueOf(montoInversion.getTipoInversionID()),
								tipoLista,
								Constantes.ENTERO_CERO,
								
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"MontosInversionDAO.listaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MONTOINVERSIONLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TasasInversionBean tasasInversion = new TasasInversionBean();
				tasasInversion.setMontoInversionID(Integer.valueOf(resultSet.getString(1)));
				tasasInversion.setMontoInversionDescripcion(resultSet.getString(2));
				return tasasInversion;
			}
		});
		return matches;
	}
	
	
	
	public void setTasasInversionDAO(TasasInversionDAO tasasInversionDAO) {
		this.tasasInversionDAO = tasasInversionDAO;
	}
	
}
