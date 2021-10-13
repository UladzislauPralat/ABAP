@VDM.viewExtension: true
@AbapCatalog.sqlViewAppendName: 'ZXMATERIAL' 
@EndUserText.label: 'Material'
extend view I_Material with ZX_Material
  association [0..1] to ZI_ProductCategory as _ProductCategory on $projection.ProductCategory = _ProductCategory.ProductCategory
  association [0..1] to ZI_ProductClass    as _ProductClass    on $projection.ProductClass = _ProductClass.ProductClass
  association [0..1] to ZI_ProductSubclass as _ProductSubclass on $projection.ProductSubClass = _ProductSubclass.ProductSubclass
  association [0..1] to ZI_ProductFamily   as _ProductFamily   on $projection.ProductFamily = _ProductFamily.ProductFamily
{
  bismt                           as OldMaterialNumber,
  @ObjectModel.foreignKey.association: '_ProductCategory'
  cast(left(prdha,2) as zproductcategory) as ProductCategory,  
  @ObjectModel.foreignKey.association: '_ProductClass'
  cast(left(prdha,5) as zproductclass) as ProductClass,        
  @ObjectModel.foreignKey.association: '_ProductSubClass'
  cast(left(prdha,8) as zproductsubclass) as ProductSubClass,  
  @ObjectModel.foreignKey.association: '_ProductFamily'
  cast(left(prdha,13) as zproductfamily) as ProductFamily,     
  mara.mstae                      as XPlantMaterialStatus,
  mara.prdha                      as ProductHierarchy,
  mara.ean11                      as UPC,
  mara.normt                      as Licensor,
  mara.ferth                      as Inventor1,
  mara.ersda                      as MaterialCreateDate,
  _ProductCategory,
  _ProductClass,
  _ProductSubclass,
  _ProductFamily 
}
