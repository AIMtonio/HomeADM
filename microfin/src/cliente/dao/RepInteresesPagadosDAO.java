package cliente.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import cliente.bean.RepInteresesPagadosBean;

public class RepInteresesPagadosDAO extends BaseDAO{

	public RepInteresesPagadosDAO () {
		super();
	}
	
	/* metodo de lista para obtener los datos para el reporte de inscriptos y preinscritos */
	  public List listaReporte(final RepInteresesPagadosBean repInteresesPagadosBean, int tipoReporte){	
			List ListaResultado=null;
			
			try{
			String query = "CALL INTERESESPAGADOSREP(?,?, ?,?,?,?,?,?,?)";

			Object[] parametros ={ 
								repInteresesPagadosBean.getFechaInicio(),
								repInteresesPagadosBean.getFechaFin(),
				    		
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
			
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL INTERESESPAGADOSREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RepInteresesPagadosBean repInteresesPagadosBean= new RepInteresesPagadosBean();
					
					repInteresesPagadosBean.setClienteID(resultSet.getString("ClienteID"));
					repInteresesPagadosBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					repInteresesPagadosBean.setInstrumentoID(resultSet.getString("InstrumentoID"));
					repInteresesPagadosBean.setFechaApertura(resultSet.getString("FechaApertura"));
					repInteresesPagadosBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					repInteresesPagadosBean.setNumDias(resultSet.getString("NumDias"));
					repInteresesPagadosBean.setMonto(resultSet.getString("Monto"));
					repInteresesPagadosBean.setTasaInteres(resultSet.getString("TasaInteres"));
					repInteresesPagadosBean.setInteresesGen(resultSet.getString("InteresesGen"));
					repInteresesPagadosBean.setISR(resultSet.getString("ISR"));
					repInteresesPagadosBean.setInteresReal(resultSet.getString("InteresReal"));
					
					
					return repInteresesPagadosBean ;
				}
			});
			ListaResultado= matches;
			}catch(Exception e){
				 e.printStackTrace();
				 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de intereses pagados", e);
			}
			return ListaResultado;
		}// fin lista report 		
	

}
