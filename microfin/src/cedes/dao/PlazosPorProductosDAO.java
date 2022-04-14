package cedes.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;

import cedes.bean.PlazosPorProductosBean;
import general.dao.BaseDAO;

public class PlazosPorProductosDAO extends BaseDAO{
	
	public PlazosPorProductosDAO(){
		super();
	}
	 
	//Lista plazos
	public List listaPlazos(int tipoLista,PlazosPorProductosBean plazosPorProductosBean){
			String query = "call PLAZOSPORPRODUCTOSLIS(?,?, ?, ?,?,?,?, ?,?,?);";
			Object[] parametros = {
					plazosPorProductosBean.getTipoInstrumentoID(),
					plazosPorProductosBean.getTipoProductoID(),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLAZOSPORPRODUCTOSLIS(" + Arrays.toString(parametros)  +")");
			
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PlazosPorProductosBean plazosPorProductos = new PlazosPorProductosBean();
					plazosPorProductos.setPlazo(resultSet.getString(1));
					return plazosPorProductos;
				}
			});
			return matches;
		}

}
