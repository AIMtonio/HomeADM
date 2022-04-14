package cliente.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import cliente.bean.RepConvenSecBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class RepConvenSecDAO extends BaseDAO{

	public RepConvenSecDAO () {
		super();
	}
	
	/* metodo de lista para obtener los datos para el reporte de inscriptos y preinscritos */
	  public List listaReporte(final RepConvenSecBean repConvenSec, int tipoReporte){	
			List ListaResultado=null;
			
			try{
			String query = "CALL CONVENSECREP(?,?,?, ?,?,?,?,?,?,?)";

			Object[] parametros ={
								Utileria.convierteFecha(repConvenSec.getFechaInicio()),
								Utileria.convierteFecha(repConvenSec.getFechaFin()),
								repConvenSec.getTipoRep(),
				    		
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
			
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CONVENSECREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RepConvenSecBean repConvenSecBean= new RepConvenSecBean();
					
					repConvenSecBean.setNoSocio(resultSet.getString("noSocio"));
					repConvenSecBean.setNombreCompleto(resultSet.getString("nombreCompleto"));
					repConvenSecBean.setNombreSucurs(resultSet.getString("nombreSucurs"));
					repConvenSecBean.setTipoRegistroDes(resultSet.getString("tipoRegistroDes"));
					repConvenSecBean.setFechaAsamblea(resultSet.getString("fechaAsamblea"));
					repConvenSecBean.setFechaRegistro(resultSet.getString("fechaRegistro"));
					
					return repConvenSecBean ;
				}
			});
			ListaResultado= matches;
			}catch(Exception e){
				 e.printStackTrace();
				 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de Asambleas", e);
			}
			return ListaResultado;
		}// fin lista report 		
	

		/* metodo de lista para obtener los datos para el reporte de prospectos */
	  public List listaReportePros(final RepConvenSecBean repConvenSec, int tipoReporte){	
			List ListaResultado=null;
			
			try{
			String query = "CALL CONVENSECREP(?,?,?, ?,?,?,?,?,?,?)";

			Object[] parametros ={
								Utileria.convierteFecha(repConvenSec.getFechaInicio()),
								Utileria.convierteFecha(repConvenSec.getFechaFin()),
								repConvenSec.getTipoRep(),
				    		
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
			
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CONVENSECREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RepConvenSecBean repConvenSecBean= new RepConvenSecBean();
					
					repConvenSecBean.setNoSocio(resultSet.getString("noSocio"));
					repConvenSecBean.setNombreCompleto(resultSet.getString("nombreCompleto"));
					repConvenSecBean.setNombreSucurs(resultSet.getString("nombreSucurs"));
					
					return repConvenSecBean ;
				}
			});
			ListaResultado= matches;
			}catch(Exception e){
				 e.printStackTrace();
				 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de Asambleas", e);
			}
			return ListaResultado;
		}// fin lista report 	
}
