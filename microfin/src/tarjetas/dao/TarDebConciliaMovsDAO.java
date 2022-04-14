package tarjetas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import tarjetas.servicio.TarDebConciliaMovsServicio;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class TarDebConciliaMovsDAO extends BaseDAO{
	
	TarDebConciliaMovsServicio tarDebConciliaMovsDAO = null;
	public TarDebConciliaMovsDAO(){
		super();
	}
	
	
	public MensajeTransaccionBean alta(final int numMovID, final int folioCargaID, final int detalle, final int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call TARDEBCONCILIAMOVSPRO(?,?,?,?,  ?,?,?,?,?,?,?);";
					Object[] parametros = {
							numMovID,
							folioCargaID, 
							detalle, 
							tipoTransaccion,
							
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"TarDebConciliaMovsDAO.alta",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
					};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBCONCILIAMOVSPRO(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							mensaje.setConsecutivoString(Utileria.completaCerosIzquierda(resultSet.getString(4), 10));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;					
				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de movimientos grid", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});		
		return mensaje;
	}
	
	public TarDebConciliaMovsServicio getTarDebConciliaMovsDAO() {
		return tarDebConciliaMovsDAO;
	}
	public void setTarDebConciliaMovsDAO(
			TarDebConciliaMovsServicio tarDebConciliaMovsDAO) {
		this.tarDebConciliaMovsDAO = tarDebConciliaMovsDAO;
	}
}
