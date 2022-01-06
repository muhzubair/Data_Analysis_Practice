
----- Standerize data format -----
SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM PortfolioProject.dbo.Nashville_housing

ALTER Table PortfolioProject.dbo.Nashville_housing
Add SaleDateConverted Date;

UPDATE PortfolioProject.dbo.Nashville_housing
SET SaleDateConverted = CONVERT(Date, SaleDate)

--- Populate Property Address ---
SELECT *
FROM PortfolioProject.dbo.Nashville_housing  
WHERE PropertyAddress IS NULL
Order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.Nashville_housing a JOIN PortfolioProject.dbo.Nashville_housing b 
ON a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL 

UPDATE a
SET PropertyAddress =  ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.Nashville_housing a JOIN PortfolioProject.dbo.Nashville_housing b 
ON a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL 

--- Breaking out Address into indivizual columns ---

SELECT PropertyAddress 
FROM PortfolioProject.dbo.Nashville_housing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM PortfolioProject.dbo.Nashville_housing
ALTER Table Nashville_housing 
Add PropertySplitAddress Nvarchar(255);

UPDATE PortfolioProject.dbo.Nashville_housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER Table PortfolioProject.dbo.Nashville_housing
Add PropertySplitCity Nvarchar(255);

UPDATE PortfolioProject.dbo.Nashville_housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT OwnerAddress
FROM PortfolioProject.dbo.Nashville_housing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM PortfolioProject.dbo.Nashville_housing

ALTER Table PortfolioProject.dbo.Nashville_housing
Add OwnerSplitAddress Nvarchar(255);

UPDATE PortfolioProject.dbo.Nashville_housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER Table PortfolioProject.dbo.Nashville_housing
Add OwnerSplitCity Nvarchar(255);

UPDATE PortfolioProject.dbo.Nashville_housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER Table PortfolioProject.dbo.Nashville_housing
Add OwnerSplitState Nvarchar(255);

UPDATE PortfolioProject.dbo.Nashville_housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)


--- Change Y and N to "Yes" and "No" in "Soldasvacant" column ---

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.Nashville_housing
Group BY SoldAsVacant
Order By 2

SELECT SoldAsVacant
,CASE When SoldAsVacant = 'Y' Then 'Yes'
	  When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant
	  END
FROM PortfolioProject.dbo.Nashville_housing

UPDATE PortfolioProject.dbo.Nashville_housing 
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
	  When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant
	  END

--- Removing Duplicates --- 
WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER  (
	PARTITION BY ParcelID, 
				 PropertyAddress, 
				 SalePrice, 
				 SaleDate, 
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM PortfolioProject.dbo.Nashville_housing
)
DELETE 
FROM RowNumCTE
WHERE row_num > 1

--- Deleting unused comments ---
SELECT * 
FROM PortfolioProject.dbo.Nashville_housing
ALTER TABLE PortfolioProject.dbo.Nashville_housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

SELECT * 
FROM PortfolioProject.dbo.Nashville_housing