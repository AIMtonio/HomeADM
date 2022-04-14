package inversiones.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import inversiones.bean.DiasInversionBean;
import inversiones.bean.TasasInversionBean;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;


public class DiasInversionDAO extends BaseDAO{
	         
	// ------------------ Propiedades y Atributos ------------------------------------------
	private TasasInversionDAO tasasInversionDAO;
	
	public DiasInversionDAO() {
		super();
	}

	public MensajeTransaccionBean altaDiaInversion(DiasInversionBean diasInversion) {
		String query = "call DIASINVERSIONALT(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				diasInversion.getTipoInvercionID(),
				diasInversion.getPlazoInferior(),
				diasInversion.getPlazoSuperior(),
				parametrosAuditoriaBean.getEmpresaID(),
				
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"DiasInversionDAO.altaDiaInversion",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()	};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIASINVERSIONALT(" + Arrays.toString(parametros) + ")");
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
	

	public MensajeTransaccionBean bajaDiasInversion(DiasInversionBean diasInversion) {
		String query = "call DIASINVERSIONBAJ(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(diasInversion.getDiaInversionID()),
				Utileria.convierteEntero(diasInversion.getTipoInvercionID()),
				parametrosAuditoriaBean.getEmpresaID(),
				
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"DiasInversionDAO.bajaDiasInversion",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIASINVERSIONBAJ(" + Arrays.toString(parametros) + ")");
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
		
	public MensajeTransaccionBean grabaListaDiasInversion(final DiasInversionBean diasInversionBean, final List listaDiasInversion ) {		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		transaccionDAO.generaNumeroTransaccion();
		
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					
					DiasInversionBean inversionBean;
					mensajeBean = bajaDiasInversion(diasInversionBean);
					
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}					
					inversiones.bean.TasasInversionBean tasaInversion = new inversiones.bean.TasasInversionBean();
					tasaInversion.setTasaInversionID("0");
					tasaInversion.setTipoInvercionID(herramientas.Utileria.convierteEntero(diasInversionBean.getTipoInvercionID()));
					mensajeBean = tasasInversionDAO.bajaTasa(tasaInversion);
					
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());	
					}
					
					for(int i=0; i<listaDiasInversion.size(); i++){
						inversionBean = (DiasInversionBean)listaDiasInversion.get(i);
						mensajeBean = altaDiaInversion(inversionBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());	
						}											
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Informacion Actualizada. NO Olvide Actualizar las Tasas de Inversion.");
					mensajeBean.setNombreControl("tipoInvercionID");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en gabacion de lista de dias de inversion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	public List lista(DiasInversionBean diasInver, int tipoLista){

		String query = "call DIASINVERSIONLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Integer.valueOf(diasInver.getTipoInvercionID()),
								tipoLista,
								Constantes.ENTERO_CERO,
								
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"DiasInversionDAO.lista",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIASINVERSIONLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				DiasInversionBean diasInver = new DiasInversionBean();
				diasInver.setDiaInversionID(String.valueOf(resultSet.getInt(1)));
				diasInver.setTipoInvercionID(String.valueOf(resultSet.getInt(2)));
				diasInver.setPlazoInferior(resultSet.getInt(3));
				diasInver.setPlazoSuperior(resultSet.getInt(4));
				return diasInver;
			}
		});
		return matches;
	}

	
	public List listaForanea(DiasInversionBean diasInver, int tipoLista){

		String query = "call DIASINVERSIONLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Integer.valueOf(diasInver.getTipoInvercionID()),
								tipoLista,
								Constantes.ENTERO_CERO,
								
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"DiasInversionDAO.listaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIASINVERSIONLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TasasInversionBean tasasInversion = new TasasInversionBean();				
				tasasInversion.setDiaInversionID(Integer.valueOf(resultSet.getString(1)));
				tasasInversion.setDiaInversionDescripcion(resultSet.getString(2));
				return tasasInversion;

			}
		});
		return matches;
	}
	

	public void setTasasInversionDAO(TasasInversionDAO tasasInversionDAO) {
		this.tasasInversionDAO = tasasInversionDAO;
	}
	
	
	
}

