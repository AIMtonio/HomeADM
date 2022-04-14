package operacionesVBC.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import operacionesVBC.bean.VbcConsultaCatalogoBean;
import operacionesVBC.beanWS.request.VbcConsultaCatalogoRequest;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import general.dao.BaseDAO;
import herramientas.Constantes;

public class VbcConsultaCatalogoDAO extends BaseDAO{

	public VbcConsultaCatalogoDAO(){
		super();
	}
	
	/* Lista de consulta de catalogos por web service*/
	public List listaCatalogosWS(VbcConsultaCatalogoRequest bean){
		List otrosCatLis = null;
			try{
			String query = "call CATALOGOSGENWSLIS(?,?,?,?,?,   ?,?,?,?,?);";
			Object[] parametros = {	bean.getNomCatalogo(),
									bean.getUsuario(),
									bean.getClave(), 
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"operacionesVBC.WS.listaCatalogosWS",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO };
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATALOGOSWSLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					VbcConsultaCatalogoBean consultaCatalogoBean = new VbcConsultaCatalogoBean();
					consultaCatalogoBean.setCampo(resultSet.getString("Id_Campo"));
					consultaCatalogoBean.setNcampo(resultSet.getString("NombreCampo"));
					consultaCatalogoBean.setPadre(resultSet.getString("Id_Padre"));
					consultaCatalogoBean.setCodigoError(resultSet.getString("NumErr"));
					consultaCatalogoBean.setMensajeError(resultSet.getString("ErrMen"));
					return consultaCatalogoBean;
					}
				});
			otrosCatLis = matches;
			}catch(Exception e){
				 e.printStackTrace();
				 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de catalogos DAO WS", e);
			}		
			return otrosCatLis;
	  }
}